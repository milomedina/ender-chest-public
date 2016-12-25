class NumExpr(Expr):
    def __init__(self, meta, num):
        assert(isinstance(num, (int, float)))

        self.meta = meta
        self.num = num

    def __str__(self):
        return '%s' % self.num
