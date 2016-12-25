class CallStmt(Stmt):
    def __init__(self, meta, func_name, args=[]):
        assert(isinstance(func_name, str) and
               isinstance(args, list))

        for arg in args:
            assert(isinstance(arg, Expr))

        self.meta = meta
        self.func_name = func_name
        self.args = args

    def __str__(self):
        args_str = ', '.join(map(lambda x: str(x), self.args))
        return '%s(%s);' % (self.func_name, args_str)
