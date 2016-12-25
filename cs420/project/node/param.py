class Param:
    def __init__(self, meta, type, ident):
        assert(isinstance(type, str) and
               isinstance(ident, Identifier))

        self.meta = meta
        self.type = type
        self.ident = ident

    def __str__(self):
        return '%s %s' % (self.type, self.ident)
