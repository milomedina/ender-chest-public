class DefaultCase:
    def __init__(self, meta, stmts, has_break=False):
        assert(isinstance(stmts, list) and
               isinstance(has_break, bool))

        for stmt in stmts:
            assert(isinstance(stmt, Stmt))

        self.meta = meta
        self.stmts = stmts
        self.has_break = has_break

    def symtab(self, pos={}, order=0):
        r_symtabs = []
        new_pos = {}
        for stmt in self.stmts:
            symtabs, _, new_pos, _ = stmt.symtab(pos=new_pos)
            r_symtabs += symtabs
        return r_symtabs, [], pos, order

    def __str__(self):
        stmts_str = '\n'.join(map(lambda x: _ast_indent(str(x)), self.stmts))
        break_str = _ast_indent('break;') if self.has_break else ''
        case_body = '\n'.join(filter(lambda x: x != '',
                                     [stmts_str, break_str]))
        return 'default:\n%s' % case_body
