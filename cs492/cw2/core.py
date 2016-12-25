from ast import BINARY_OP, UNARY_OP, OP, Terminal, NonTerminal
from parser import parse_expr
from collections import deque
import math
import random


CONFIG = {
    'LABEL': [],
    'CONST': [],

    'DATA_LEN': 0,
    'DATA_ENV': {},
    'MSE_MAX': 1e299,
    'PRESERV_MAX': 10,

    'ITER_NUM': 200,
    'POP_SIZE': 2000,
    'PRESERV_NUM': 1000,

    'PROB_OP': {},
    'VERBOSE': False,

    '_OP': 0,
}


_q = deque()


def load_data(data, label):
    CONFIG['DATA_LEN'] = len(data)
    for i in range(CONFIG['DATA_LEN']):
        xs, y = data[i]
        env = {}
        for j in range(len(xs)):
            env[(j+1)] = xs[j]
        CONFIG['DATA_ENV'][i] = (env, y)
    CONFIG['LABEL'] = list(range(1, len(label) + 1))


def set_config(args):
    for k, v in args.items():
        CONFIG[k] = v
    for o in OP:
        CONFIG['_OP'] += CONFIG['PROB_OP'][o]


def calc_mse(expr):
    s = 0
    for i in range(CONFIG['DATA_LEN']):
        env, y = CONFIG['DATA_ENV'][i]
        val = expr.eval(env)
        s += math.pow(val - y, 2)
    return s / CONFIG['DATA_LEN']


def calc_mse_safe(expr):
    if expr.num_literial() == 0:
        return CONFIG['MSE_MAX']
    if expr.height() > 30:
        return CONFIG['MSE_MAX']

    try:
        return min(calc_mse(expr), CONFIG['MSE_MAX'])
    except:
        return CONFIG['MSE_MAX']


def _random_op():
    r = random.random() * CONFIG['_OP']
    for o in OP:
        r -= CONFIG['PROB_OP'][o]
        if r <= 0:
            return o


def _random_child(depth, depth_limit, term_rate):
    if depth < depth_limit and random.random() > term_rate:
        child = NonTerminal(_random_op())
        return child

    if random.randint(0, 1) == 0:
        child = Terminal(num=random.choice(CONFIG['CONST']))
    else:
        child = Terminal(var=random.choice(CONFIG['LABEL']))
    return child


def _random_expr(depth_limit, term_rate):
    if depth_limit == 0:
        return _random_child(0, 0, term_rate)

    root = NonTerminal(_random_op())
    _q.append((root, 0))

    while _q:
        node, depth = _q.popleft()

        lchild  = _random_child(depth, depth_limit, term_rate)
        node.lhs = lchild
        if isinstance(lchild, NonTerminal):
            _q.append((lchild, depth + 1))

        if node.type == 'UNARY': continue

        rchild  = _random_child(depth, depth_limit, term_rate)
        node.rhs = rchild
        if isinstance(rchild, NonTerminal):
            _q.append((rchild, depth + 1))

    return root


def _random(population, max_depth):
    exprs = []
    while len(exprs) < population:
        depth_limit = random.randint(1, max_depth)
        term_rate = random.uniform(0, 0.8)
        expr = _random_expr(depth_limit, term_rate)
        if expr.num_literial() == 0:
            continue
        exprs.append(expr)
    return exprs


def _pick_node_core(expr, term_rate):
    _q.append((None, expr))

    term = []
    nonterm = [(None, expr), ]
    while _q:
        parent, node = _q.popleft()
        if isinstance(node, Terminal):
            term.append((parent, node))
            continue

        nonterm.append((parent, node))
        _q.append((node, node.lhs))
        if node.type == 'BINARY':
            _q.append((node, node.rhs))

    if random.random() < term_rate:
        return random.choice(term)
    return random.choice(nonterm)


def _pick_node(expr, term_rate, max_height=-1):
    parent, node = _pick_node_core(expr, term_rate)
    if max_height == -1:
        return parent, node

    while node.height() > max_height:
        parent, node = _pick_node_core(expr, term_rate)
    return parent, node


def _mutate_subtree(expr):
    parent, node = _pick_node(expr, 0)
    if parent is None:
        return expr

    new_expr = _random_expr(node.height() - 1, 0)
    if parent.lhs == node:
        parent.lhs = new_expr
    else:
        parent.rhs = new_expr
    return expr


def _crossover(expr1, expr2, term_rate):
    expr1, expr2 = expr1.copy(), expr2.copy()
    if random.randint(0, 1) == 1:
        expr1, expr2 = expr2, expr1

    par1, node1 = _pick_node(expr1, term_rate)
    if par1 is None: return None

    if random.randint(0, 1) == 0:
        par2, node2 = _pick_node(expr2, term_rate)
    else:
        par2, node2 = _pick_node(expr2, term_rate, node1.height())
    if par2 is None: return None

    if par1.lhs == node1:
        par1.lhs = node2
    else:
        par1.rhs = node2
    return expr1


def _select_exp(prob_func, size):
    r, acc = random.random(), 0
    for i in range(size):
        acc += prob_func(i)
        if acc >= r:
            return i
    return size - 1


def _train_one(population, selection_mode='FPS'):
    population = sorted(population, key=lambda x: x[1])
    children = []

    n_pop = len(population)
    if selection_mode == 'FPS':
        _S = sum(map(lambda x: 1 / x[1], population))
        P = lambda i: 1 / (population[i][1] * _S)
    elif selection_mode == 'EXP':
        _S = sum(map(lambda i: 1 - math.exp(-i), range(n_pop)))
        P = lambda i: (1 - math.exp(-i) / _S)
    elif selection_mode == 'LINE':
        _S = sum(map(lambda i: i, range(n_pop)))
        P = lambda i: (0.5 / n_pop) + i * 0.5 / _S
    else:
        raise AssertionError('invalid selection mode')

    while len(children) < CONFIG['POP_SIZE'] - CONFIG['PRESERVE_NUM']:
        expr1 = population[_select_exp(P, CONFIG['POP_SIZE'])][0]
        expr2 = population[_select_exp(P, CONFIG['POP_SIZE'])][0]
        expr = _crossover(expr1, expr2, 0.1)
        if expr is None or expr.num_literial() == 0:
            continue

        if random.random() < 0.2:
            expr = _mutate_subtree(expr)

        mse = calc_mse_safe(expr)
        if mse >= CONFIG['PRESERV_MAX']:
            continue
        children.append((expr, mse))
    return population[:CONFIG['PRESERVE_NUM']] + children


def _dump(population):
    with open('cache.txt', 'w') as f:
        for expr, mse in population:
            f.write('%s;%s\n' % (expr.to_postfix(), mse))
    print('train: computation has been dumped in cache.txt')


def _recover():
    with open('cache.txt', 'r') as f:
        lines = f.readlines()

    population = []
    for line in lines:
        if line.strip() == '':
            continue

        r_expr, mse = line.strip().split(';')
        parsed, expr = parse_expr(r_expr)
        if not parsed:
            continue
        population.append((expr, float(mse)))
    return population


def train(recover=False):
    population = _recover() if recover else []
    init_tree = _random(CONFIG['POP_SIZE'] - len(population), 5)
    population = population + list(map(lambda x: (x, calc_mse_safe(x)), init_tree))

    for i in range(CONFIG['ITER_NUM']):
        try:
            mode = 'FPS' # if i < 5 else 'LINE'
            population = _train_one(population, mode)
            if CONFIG['VERBOSE']:
                top = population[0]
                print('= Iteration %s =' % i)
                list(map(lambda x: print('POP: cost=%s, expr=%s' % (x[1], x[0])), population[:50]))
                print('TOP: cost=%s, expr=%s, postfix=%s' % (top[1], top[0], top[0].to_postfix()))
                print()
        except KeyboardInterrupt:
            _dump(population)
            exit(1)

    population = sorted(population, key=lambda x: x[1])
    return population[0]
