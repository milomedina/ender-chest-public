class NullStmt(Stmt):
    def __init__(self, meta):
        self.meta = meta

    def __str__(self):
        return ';'
