class SymDef:
    def __init__(self, name, type, role, arr_size=None):
        self.name = name
        self.type = type
        self.role = role
        self.arr_size = arr_size

    def __str__(self):
        arr_size = '' if self.arr_size is None else '[%s]' % d.arr_size
        return '%s %s %s%s' % (self.role, self.type, self.name, arr_size)


class SymTab:
    # type: PROGRAM, FUNC, COMPOUND, WHILE, DOWHILE, FOR, SWITCH, CASE, IF
    # id: 1, 2, 3, ... or func name, global, ...
    # defs: list of (order, INT|FLOAT, name, arr_size, VAR|PARM)
    # symtabs: list of symtab
    def __init__(self, type, id, defs, symtabs):
        self.type = type
        self.id = id
        self.defs = defs
        self.symtabs = symtabs

    def _id2str(self):
        if self.type == 'PROGRAM':
            return 'GLOBAL'
        elif self.type == 'FUNC':
            return 'FUNC(NAME: %s)' % self.id
        elif self.type == 'CASE':
            return 'CASE(NUM: %s)' % self.id
        elif self.type == 'DEFAULT':
            return 'DEFAULT'
        return '%s(ORDER: %s)' % (self.type, self.id)

    def _to_str(self, path):
        path = path + [self._id2str(), ]
        id_str = ' - '.join(path)

        buf = ''
        if len(self.defs) > 0:
            buf += "* %s\n" % id_str
            buf += "{:>5}{:>15}{:>8}{:>8}{:>8}\n"\
                    .format("ORDER", "NAME", "TYPE", "SIZE", "ROLE")

            order = 1
            for d in self.defs:
                arr_size = '' if d.arr_size is None else d.arr_size
                buf += "{:>5}{:>15}{:>8}{:>8}{:>8}\n"\
                        .format(order, d.name, d.type, arr_size, d.role)
                order += 1

            buf += '\n'

        for s in self.symtabs:
            buf += s._to_str(path)
        return buf

    def to_dict(self, path=[]):
        result = {}
        path = path + [self._id2str(), ]
        for d in self.defs:
            result[d.name] = d

        for s in self.symtabs:
            symtab = s.to_dict(path)
            result.update(symtab)
        return result

    def __str__(self):
        return self._to_str([])
