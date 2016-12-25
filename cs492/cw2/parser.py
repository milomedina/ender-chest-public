from ast import BINARY_OP, UNARY_OP, NonTerminal, Terminal


def _is_float(s):
    try:
        return True, float(s)
    except:
        return False, 0


def _parse_expr(tokens):
    stack = []

    for tok in tokens:
        if tok in BINARY_OP:
            rhs = stack.pop()
            lhs = stack.pop()
            stack.append(NonTerminal(tok, lhs, rhs))
        elif tok in UNARY_OP:
            lhs = stack.pop()
            stack.append(NonTerminal(tok, lhs))
        else:
            is_float, val = _is_float(tok)
            if is_float:
                term = Terminal(num=val)
            else:
                term = Terminal(var=int(tok[1:]))
            stack.append(term)

    assert(len(stack) == 1)
    return stack.pop()


def parse_expr(expr):
    tokens = list(filter(lambda x: x != '', expr.split(' ')))
    try:
        return True, _parse_expr(tokens)
    except:
        return False, None


def parse_data(lines):
    data = []
    label = lines[0].split(',')[:-1]
    for line in lines[1:]:
        vals = list(map(lambda x: float(x), line.split(',')))
        xs, y = vals[0:-1], vals[-1]
        data.append((xs, y))
    return data, label


if __name__ == '__main__':
    obj = parse_expr("x24 2.0 ^ 2.0 ~ x3 * sin -")[1]
    print('infix: %s' % obj)
    print('postfix: %s' % obj.to_postfix())
