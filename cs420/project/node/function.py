class Function:
    def __init__(self, meta, type, func_name, params, body):
        assert(isinstance(type, str) and
               isinstance(func_name, str) and
               isinstance(params, list) and
               isinstance(body, CompoundStmt))

        for param in params:
            assert(isinstance(param, Param))

        self.meta = meta
        self.type = type
        self.func_name = func_name
        self.params = params
        self.body = body

    def symtab(self, pos={}, order=0):
        param_defs = []
        for param in self.params:
            order += 1
            param_defs.append(SymDef(param.ident.var_name, param.type, 'PARAM', param.ident.arr_size))

        symtabs, _, _, _ = self.body.symtab(order=order)

        return [SymTab('FUNC', self.func_name, param_defs + symtabs[0].defs, symtabs[0].symtabs), ], [], pos, order

    def __str__(self):
        params_str = ", ".join(map(lambda x: str(x), self.params))
        return '%s %s(%s)\n%s' % (self.type, self.func_name, params_str, self.body)
