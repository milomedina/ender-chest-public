from z3 import *

import subprocess
import sys
import os
import shutil


ROOT_PATH = os.path.dirname(os.path.abspath(__file__))
SOOT_DIR = os.path.join(ROOT_PATH, 'soot')
SOOT_PATH = os.path.join(SOOT_DIR, 'soot.sh')


# class EXPR: (op, left, right)
# - Denote arithmetic, boolean expression, variables, and constant
# - op: operator, left: left-side, right: right-side (can be null)
# - If variable, op is 'V', and if constant, op is 'C'
# - If assertionDisabled object, op is 'A'
class EXPR:
    def __init__(self, op, left, right=None):
        self.op = op
        self.left = left
        self.right = right

    def __repr__(self):
        return '%s' % self

    def __str__(self):
        if self.op == 'V':
            return '(%s)' % self.left
        elif self.op == 'C':
            return '%s' % self.left
        elif self.op == 'A':
            return 'ASSERT'
        elif self.op == '!':
            return '(! %s)' % (self.left)
        return '(%s %s %s)' % (self.left, self.op, self.right)


# class STMT: com, no, label, expr, target, phi
# - Denote one statements (or instruction)
# - com: command, no: special number given by shimple converter,
# - label: name of label of label statements,
# - expr: expression if if and assign statements,
# - target: target label name if goto and if statements,
# - phi: dictionary ({no: name}) if phi statements
# - 'R': return, 'T': throw, 'G': goto, 'L': label, 'I': if, 'N': nop,
# - 'D': declare, 'A': assignment, 'C': phi
class STMT:
    def __init__(self, com, no=None, label=None, expr=None, target=None, phi=None):
        self.com = com
        self.no = no
        self.label = label
        self.expr = expr
        self.target = target
        self.phi = phi

    def __repr__(self):
        return '%s' % self

    def __str__(self):
        prefix = '(%s) ' % self.no if self.no != -1 else ''
        core = ''
        if self.com == 'R':
            core = 'RETURN'
        elif self.com == 'T':
            core = 'THROW'
        elif self.com == 'G':
            core = 'GOTO: %s' % self.target
        elif self.com == 'L':
            core = 'LABEL: %s' % self.label
        elif self.com == 'I':
            core = 'IF %s THEN GOTO %s' % (self.expr, self.target)
        elif self.com == 'N':
            core = 'NOP'
        elif self.com == 'D':
            core = 'DECLARE %s INT' % self.target
        elif self.com == 'A':
            core = '%s = %s' % (self.target, self.expr)
        elif self.com == 'C':
            core = '%s = PHI(%s)' % (self.target, self.phi)
        return prefix + core


# filter useless line - empty line and comment line
# - lines: string list
def filter_useless(lines):
    new_lines = []
    for line in lines:
        line = line.strip()
        if not line or (len(line) >= 2 and line[0:2] == '/*'):
            continue
        new_lines.append(line)
    return new_lines


# extract lines are in testMe method
# - lines: string list
def extract_test_me(lines):
    i_start = -1
    for i in range(len(lines)):
        if 'testMe' in lines[i]:
            i_start = i
            arg_start = lines[i].find('(')
            arg_end = lines[i].find(')')
            argn = lines[i].count('int', arg_start, arg_end)
            break

    for i in range(i_start, len(lines)):
        if lines[i] == '}':
            return lines[i_start+2:i], argn


# parse the instructions
# - lines: string list
def parse(lines):
    # build EXPR object for unit - variables or constant
    def unit_expr(name):
        try:
            return EXPR('C', int(name))
        except:
            return EXPR('V', name)

    # build EXPR object for non-unit
    def build_expr(op, left, right):
        return EXPR(op, unit_expr(left), unit_expr(right))

    stmts = []
    params = []
    labels = {}
    for i in range(len(lines)):
        line = lines[i]
        line = line[0:-1] if line[-1] == ';' else line

        # parse special "number" given by shimple converter
        no = -1
        tokens = filter(bool, line.split(' '))
        if tokens[0][0] == '(':
            no = int(tokens[0][1:-1])
            tokens = tokens[1:]

        if tokens[0] == 'return':
            stmts.append(STMT('R', no))
        elif tokens[0] == 'throw':
            stmts.append(STMT('T', no))
        elif tokens[0] == 'goto':
            stmts.append(STMT('G', no, target=tokens[1]))
        elif tokens[0][-1] == ':':
            labels[tokens[0][0:-1]] = len(stmts)
            stmts.append(STMT('L', no, label=tokens[0][0:-1]))
        elif tokens[0] == 'if':
            expr = build_expr(tokens[2], tokens[1], tokens[3])
            stmts.append(STMT('I', no, target=tokens[5], expr=expr))
        elif tokens[0] == 'nop':
            stmts.append(STMT('N', no))
        elif tokens[1] == ':=':
            var_name = tokens[0]
            var_class = tokens[2][0:-1]
            var_type = tokens[3]
            # ignore non-int declaration
            if '@parameter' not in var_class or var_type != 'int':
                continue

            stmts.append(STMT('D', no, target=var_name))
            params.append(var_name)
        elif tokens[1] == '=':
            var_name = tokens[0]
            var_input = tokens[2:]
            is_assert = any(map(lambda x: 'assert' in x, var_input))
            # ignore object assignment except assertionDisabled
            if not is_assert and (var_input[0][0] == '<' or var_input[0] == 'new'):
                continue

            # parse for Phi expression
            if var_input[0].startswith('Phi'):
                var_input[0] = var_input[0][4:]
                var_input[-1] = var_input[-1][:-1]

                d = {}
                for j in range(0, len(var_input), 2):
                    num = var_input[j+1][1:]
                    num = num[:-1] if num[-1] == ',' else num
                    d[int(num)] = var_input[j]
                stmts.append(STMT('C', no, target=var_name, phi=d))
                continue
            elif is_assert:
                expr = EXPR('A', 0)
            elif len(var_input) > 1:
                expr = build_expr(var_input[1], var_input[0], var_input[2])
            else:
                expr = unit_expr(var_input[0])
            stmts.append(STMT('A', no, target=var_name, expr=expr))
    return stmts, params, labels


# make z3 expression from EXPR objects
# - variables: variable name -> z3 expression mapping
# - expr: EXPR objects to convert
def make_z3expr(variables, expr):
    def subst(expr):
        if expr.op == 'C':
            return expr.left
        elif expr.op == 'V':
            return variables[expr.left]
        elif expr.op == 'A':
            return 'A'
        return expr

    op = expr.op

    # if unit EXPR, return unit z3 expression - constant or variables
    if op == 'C':
        return expr.left, 0
    elif op == 'V':
        return variables[expr.left], 0
    elif op == 'A':
        return 'A', 0

    left = subst(expr.left)
    right  = subst(expr.right)

    f1, f2 = False, False
    try: f1 = left == 'A'
    except: pass
    try: f2 = right == 'A'
    except: pass

    # if one of left and right is assertion objects, returns whether
    # the branch should always taken or always not taken
    if f1 or f2:
        v = right if f1 else left
        if (op == '==' and v == 0) or (op == '!=' and v != 0):
            return None, 1
        elif (op == '==' and v != 0) or (op == '!=' and v == 0):
            return None, -1

    # otherwise build z3 expression
    if op == '+':
        return left + right, 0
    elif op == '-':
        return left - right, 0
    elif op == '*':
        return left * right, 0
    elif op == '/':
        return left / right, 0
    elif op == '==':
        return left == right, 0
    elif op == '!=':
        return left != right, 0
    elif op == '>':
        return left > right, 0
    elif op == '<':
        return left < right, 0
    elif op == '>=':
        return left >= right, 0
    elif op == '<=':
        return left <= right, 0
    elif op == '|':
        return Or(left, right), 0
    elif op == '&':
        return And(left, right), 0
    elif op == '!':
        return Not(left), 0
    return 0, 0


# analyze the parsed STMT objects
# - stmt: parsed STMT objects
# - labels: label name -> line number mapping
# - variables: variable name -> z3 expression mapping
# - condition: current condition
# - loc: current line number
# - state: current "state number" given by shimple converter
def analyze(stmts, labels, variables, condition, loc, state):
    loc -= 1
    while loc < len(stmts):
        loc += 1
        stmt = stmts[loc]
        if stmt.no != -1:
            state = stmt.no
        if stmt.com == 'R':
            return []
        elif stmt.com == 'T':
            return [condition, ] if condition else []
        elif stmt.com == 'N':
            continue
        elif stmt.com == 'G':
            return analyze(stmts, labels, variables, condition, labels[stmt.target], state)
        elif stmt.com == 'I':
            expr, flag = make_z3expr(variables, stmt.expr)
            if flag == 1:
                return analyze(stmts, labels, variables, condition, labels[stmt.target], state)
            elif flag == -1:
                continue

            if condition:
                nt_cond = And(Not(expr), condition)
                t_cond = And(expr, condition)
            else:
                nt_cond = Not(expr)
                t_cond = expr

            # recursive call for taken and not-taken
            not_taken = analyze(stmts, labels, variables, nt_cond, loc + 1, state)
            taken = analyze(stmts, labels, variables, t_cond, labels[stmt.target], state)
            return not_taken + taken
        elif stmt.com == 'C':
            expr, flag = make_z3expr(variables, EXPR('V', stmt.phi[state]))
            variables[stmt.target] = expr
        elif stmt.com == 'A':
            expr, flag = make_z3expr(variables, stmt.expr)
            variables[stmt.target] = expr
    return [condition, ]


# the main routine of the program
def main():
    if len(sys.argv) < 2:
        print 'usage: python verify.py <java source file>'
        exit(1)

    # file existance check
    path = os.path.abspath(sys.argv[1])
    if not os.path.isfile(path):
        print '404: File NOT FOUND'
        print 'The program could always use new inputs. EXCEPT THIS'
        exit(1)

    # copy file to SOOT directory
    try:
        shutil.copy2(path, SOOT_DIR)
    except:
        pass

    f_dir, f_name = os.path.split(path)
    f_name = f_name.replace('.java', '')

    # call soot
    os.chdir(SOOT_DIR)
    subprocess.call([SOOT_PATH, f_name])
    f_name += '.shimple'

    # read the .shimple file
    with open(os.path.join(SOOT_DIR, f_name), 'r') as f:
        lines = f.readlines()

    # filter useless, extract testMe, and parse
    lines = filter_useless(lines)
    lines, argn = extract_test_me(lines)
    stmts, params, labels = parse(lines)

    # made initial variable mapping for parameters
    variables = {}
    for param in params:
        variables[param] = Int(param)

    # call analyze to collect conditions
    conditions = analyze(stmts, labels, variables, None, 0, -1)

    # fold the conditions with OR operator
    cond = None
    for condition in conditions:
        if not cond:
            cond = condition
        else:
            cond = Or(cond, condition)

    # call z3 solver
    s = Solver()
    s.add(cond)
    result = s.check().__repr__()
    if result == 'sat':
        # if sat, find model
        print 'NOT VALID:',
        model = s.model()
        ans = {}
        for d in model.decls():
            ans[d.name()] = model[d]

        # if there are no specified value on the model, print 0
        for p in params:
            v = ans[p] if p in ans else 0
            print '%s = %s;' % (p, v),
    else:
        # if unsat, valid
        print 'VALID'

if __name__ == '__main__':
    main()
