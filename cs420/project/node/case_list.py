class CaseList:
    def __init__(self, meta, num_cases, default_case=None):
        assert(isinstance(num_cases, list) and
               isinstance(default_case, (type(None), DefaultCase)))

        for case in num_cases:
            assert(isinstance(case, NumCase))

        self.meta = meta
        self.num_cases = num_cases
        self.default_case = default_case

    def symtab(self, pos={}, order=0):
        r_symtabs = []

        for case in self.num_cases:
            symtabs, _, _, _ = case.symtab()
            r_symtabs.append(SymTab('CASE', case.int_num, [], symtabs))

        if self.default_case is not None:
            symtabs, _, _, _ = self.default_case.symtab()
            r_symtabs.append(SymTab('DEFAULT', '', [], symtabs))

        return r_symtabs, [], pos, order

    def __str__(self):
        num_cases_str = '\n'.join(map(lambda x: _ast_indent(str(x)), self.num_cases))
        default_case_str = '' if self.default_case is None \
                              else _ast_indent(str(self.default_case))
        return '\n'.join(filter(lambda x: x != '', [num_cases_str,
                                                    default_case_str]))
