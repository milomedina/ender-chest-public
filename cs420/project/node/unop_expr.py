class UnopExpr(Expr):
    def __init__(self, meta, op, expr):
        assert(isinstance(op, str) and
               isinstance(expr, Expr))

        self.meta = meta
        self.op = op
        self.expr = expr

    def __str__(self):
        return '(%s%s)' % (self.op, self.expr)
