class Program:
    def __init__(self, meta, decls=[], funcs=[]):
        assert(isinstance(decls, list) and
               isinstance(funcs, list))

        for decl in decls:
            assert(isinstance(decl, Declaration))

        for func in funcs:
            assert(isinstance(func, Function))

        self.meta = meta
        self.decls = decls
        self.funcs = funcs

    def symtab(self, pos={}, order=0):
        r_defs = []
        for decl in self.decls:
            _, defs, _, order = decl.symtab(order=order)
            r_defs += defs

        r_symtabs = []
        for func in self.funcs:
            symtabs, _, _, _ = func.symtab()
            r_symtabs += symtabs

        return [SymTab('PROGRAM', '', r_defs, r_symtabs), ], [], pos, order

    def __str__(self):
        decls_str = '\n'.join(map(lambda x: str(x), self.decls))
        funcs_str = '\n'.join(map(lambda x: str(x), self.funcs))
        return '\n'.join(filter(lambda x: x != '',
                                  [decls_str, funcs_str]))
