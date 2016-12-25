class RetStmt(Stmt):
    def __init__(self, meta, expr=None):
        assert(isinstance(expr, (type(None), Expr)))

        self.meta = meta
        self.expr = expr

    def __str__(self):
        ret = '' if self.expr is None else ' %s' % self.expr
        return 'return%s;' % ret
