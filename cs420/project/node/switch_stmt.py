class SwitchStmt(Stmt):
    def __init__(self, meta, id, cases):
        assert(isinstance(id, Identifier) and
               isinstance(cases, CaseList))

        self.meta = meta
        self.id = id
        self.cases = cases

    def symtab(self, pos={}, order=0):
        pos['switch'] = pos.get('switch', 0) + 1

        symtabs, _, _, _ = self.cases.symtab()
        return [SymTab('SWITCH', pos['switch'], [], symtabs), ], [], pos, order

    def __str__(self):
        return 'switch (%s) {\n%s\n}' % (self.id, self.cases)
