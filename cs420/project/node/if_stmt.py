class IfStmt(Stmt):
    def __init__(self, meta, cond, if_body, else_body=None):
        assert(isinstance(cond, Expr) and
               isinstance(if_body, Stmt) and
               isinstance(else_body, (type(None), Stmt)))

        self.meta = meta
        self.cond = cond
        self.if_body = if_body
        self.else_body = else_body

    def symtab(self, pos={}, order=0):
        pos['if'] = pos.get('if', 0) + 1
        r_symtabs = []

        symtabs, _, _, _ = self.if_body.symtab()
        if isinstance(self.if_body, CompoundStmt):
            r_symtabs.append(SymTab('IF', pos['if'], symtabs[0].defs, symtabs[0].symtabs))
        else:
            r_symtabs.append(SymTab('IF', pos['if'], [], symtabs))

        if self.else_body is None:
            return r_symtabs, [], pos, order

        symtabs, _, _, _ = self.else_body.symtab()
        if isinstance(self.else_body, CompoundStmt):
            r_symtabs.append(SymTab('ELSE', pos['if'], symtabs[0].defs, symtabs[0].symtabs))
        else:
            r_symtabs.append(SymTab('ELSE', pos['if'], [], symtabs))

        return r_symtabs, [], pos, order

    def __str__(self):
        body_str = str(self.if_body)
        if not isinstance(self.if_body, CompoundStmt):
            body_str = _ast_indent(body_str)

        else_str = ''
        if self.else_body is not None:
            else_body_str = str(self.else_body)
            if not isinstance(self.else_body, CompoundStmt):
                else_body_str = _ast_indent(else_body_str)
            else_str = '\nelse\n%s' % else_body_str

        return 'if (%s)\n%s%s' % (self.cond, body_str, else_str)
