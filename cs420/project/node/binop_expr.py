class BinopExpr(Expr):
    def __init__(self, meta, op, lexpr, rexpr):
        assert(isinstance(op, str) and
               isinstance(lexpr, Expr) and
               isinstance(rexpr, Expr))

        self.meta = meta
        self.op = op
        self.lexpr = lexpr
        self.rexpr = rexpr

    def __str__(self):
        return '(%s %s %s)' % (self.lexpr, self.op, self.rexpr)
