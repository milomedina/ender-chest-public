class Declaration:
    def __init__(self, meta, type, idents):
        assert(isinstance(type, str) and
               isinstance(idents, list))

        for ident in idents:
            assert(isinstance(ident, Identifier))

        self.meta = meta
        self.type = type
        self.idents = idents

    def symtab(self, pos={}, order=0):
        defs = []
        for ident in self.idents:
            order += 1
            defs.append(SymDef(ident.var_name, self.type, 'VAR', ident.arr_size))
        return [], defs, pos, order

    def __str__(self):
        idents_str = ', '.join(map(lambda x: str(x), self.idents))
        return '%s %s;' % (self.type, idents_str)
