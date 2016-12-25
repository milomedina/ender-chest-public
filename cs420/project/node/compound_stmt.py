class CompoundStmt(Stmt):
    def __init__(self, meta, decls, stmts):
        assert(isinstance(decls, list) and
               isinstance(stmts, list))

        for decl in decls:
            assert(isinstance(decl, Declaration))

        for stmt in stmts:
            assert(isinstance(stmt, Stmt))

        self.meta = meta
        self.decls = decls
        self.stmts = stmts

    def symtab(self, pos={}, order=0):
        pos['compound'] = pos.get('compound', 0) + 1

        r_defs = []
        for decl in self.decls:
            _, defs, _, order = decl.symtab(order=order)
            r_defs += defs

        r_symtabs = []
        new_pos = {}
        for stmt in self.stmts:
            symtabs, _, new_pos, _ = stmt.symtab(pos=new_pos)
            r_symtabs += symtabs

        return [SymTab('COMPOUND', pos['compound'], r_defs, r_symtabs), ], [], pos, order

    def __str__(self):
        decls_str = '\n'.join(map(lambda x: _ast_indent(str(x)), self.decls))
        stmts_str = '\n'.join(map(lambda x: _ast_indent(str(x)), self.stmts))
        lines = '\n'.join(filter(lambda x: x != '', [decls_str, stmts_str]))

        return '{\n' + lines + '\n}' if lines else '{\n}'
