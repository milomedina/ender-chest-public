import math


BINARY_OP = {
    '+': lambda x, y: x + y,
    '-': lambda x, y: x - y,
    '*': lambda x, y: x * y,
    '/': lambda x, y: x / y if y != 0 else 1,
    '^': lambda x, y: math.pow(x, y),
}


UNARY_OP = {
    '~': lambda x: -x,
    'abs': lambda x: abs(x),
    'sin': lambda x: math.sin(x),
    'cos': lambda x: math.cos(x),
    'tan': lambda x: math.tan(x),
    'asin': lambda x: math.asin(x),
    'acos': lambda x: math.acos(x),
    'atan': lambda x: math.atan(x),
    'sinh': lambda x: math.sinh(x),
    'cosh': lambda x: math.cosh(x),
    'tanh': lambda x: math.tanh(x),
    'exp': lambda x: math.exp(x),
    'sqrt': lambda x: math.sqrt(x),
    'log': lambda x: math.log(x),
}


OP = list(BINARY_OP.keys()) + list(UNARY_OP.keys())


class NonTerminal:
    def __init__(self, op, lhs=None, rhs=None):
        assert(op in BINARY_OP or op in UNARY_OP)
        self.type = 'BINARY' if op in BINARY_OP else 'UNARY'
        self.op = op
        self.lhs = lhs
        self.rhs = rhs

    def copy(self):
        lhs = None if self.lhs is None else self.lhs.copy()
        rhs = None if self.rhs is None else self.rhs.copy()
        return NonTerminal(self.op, lhs, rhs)

    def height(self):
        if self.type == 'BINARY':
            return max(self.lhs.height(), self.rhs.height()) + 1
        return self.lhs.height() + 1

    def num_literial(self):
        if self.type == 'BINARY':
            return self.lhs.num_literial() + self.rhs.num_literial()
        return self.lhs.num_literial()

    def eval(self, env):
        lvalue = self.lhs.eval(env)
        if self.type == 'BINARY':
            rvalue = self.rhs.eval(env)
            return BINARY_OP[self.op](lvalue, rvalue)
        return UNARY_OP[self.op](lvalue)

    def to_postfix(self):
        if self.type == 'BINARY':
            return '%s %s %s' % (self.lhs.to_postfix(),
                                 self.rhs.to_postfix(), self.op)
        return '%s %s' % (self.lhs.to_postfix(), self.op)

    def __str__(self):
        if self.type == 'BINARY':
            return '(%s) %s (%s)' % (self.lhs, self.op, self.rhs)
        return '%s(%s)' % (self.op, self.lhs)


class Terminal:
    def __init__(self, var=None, num=None):
        if var is not None:
            self.type = 'VAR'
        else:
            self.type = 'NUM'
        self.var = var
        self.num = num

    def copy(self):
        return Terminal(self.var, self.num)

    def height(self):
        return 0

    def num_literial(self):
        return 1 if self.type == 'VAR' else 0

    def eval(self, env):
        if self.type == 'NUM':
            return self.num
        return env[self.var]

    def to_postfix(self):
        return str(self)

    def __str__(self):
        return str(self.num) if self.type == 'NUM' else 'x%s' % self.var
