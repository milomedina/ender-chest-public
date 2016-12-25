class AssignStmt(Stmt):
    def __init__(self, meta, var_name, expr, arr_expr=None):
        assert(isinstance(var_name, str) and
               isinstance(expr, Expr) and
               isinstance(arr_expr, (type(None), Expr)))

        self.meta = meta
        self.var_name = var_name
        self.arr_expr = arr_expr
        self.expr = expr

    def __str__(self):
        arr = '' if self.arr_expr is None else '[%s]' % self.arr_expr
        return '%s%s = %s;' % (self.var_name, arr, self.expr)
