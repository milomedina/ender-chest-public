class ForStmt(Stmt):
    def __init__(self, meta, init, cond, iter, body):
        assert(isinstance(init, AssignStmt) and
               isinstance(cond, Expr) and
               isinstance(iter, AssignStmt) and
               isinstance(body, Stmt))

        self.meta = meta
        self.init = init
        self.cond = cond
        self.iter = iter
        self.body = body

    def symtab(self, pos={}, order=0):
        pos['for'] = pos.get('for', 0) + 1

        symtabs, _, _, _ = self.body.symtab()
        if isinstance(self.body, CompoundStmt):
            return [SymTab('FOR', pos['for'], symtabs[0].defs, symtabs[0].symtabs), ], [], pos, order
        return [SymTab('FOR', pos['for'], [], symtabs), ], [], pos, order

    def __str__(self):
        body_str = str(self.body)
        if not isinstance(self.body, CompoundStmt):
            body_str = _ast_indent(body_str)

        return 'for (%s%s;%s)\n%s' % (self.init, self.cond,
                                      str(self.iter)[:-1], body_str)
