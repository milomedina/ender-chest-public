class IDExpr(Expr):
    def __init__(self, meta, id, arr_expr=None):
        assert(isinstance(id, str) and
               isinstance(arr_expr, (type(None), Expr)))

        self.meta = meta
        self.id = id
        self.arr_expr = arr_expr

    def __str__(self):
        arr_str = '[%s]' % self.arr_expr if self.arr_expr else ''
        return '%s%s' % (self.id, arr_str)
