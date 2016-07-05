"""
class Prop
- denotes one proposition formula
- for A [and, or, imp, rev imp, eq] B:
    op=[&, |, >, <, =], l=A, r=B, t=None
- for NOT A:
    op=!, l=A, r=None, t=None
- for a:
    op=None, l=None, r=None, t=a
"""
class Prop:
    def __init__(self, op, l, r=None, t=None):
        self.op = op
        self.l = l
        self.r = r
        self.t = t

    def str2prefix(self):
        if not self.op:
            return self.t
        elif self.op == '-':
            return '- %s' % self.l.str2prefix()
        return '%s %s %s' % (self.op, self.l.str2prefix(), self.r.str2prefix())

    def __str__(self):
        if not self.op:
            return self.t
        elif self.op == '-':
            return '-%s' % self.l
        return '(%s)%s(%s)' % (self.l, self.op, self.r)

"""
def Atom: str -> Prop
- simple constructor for an atom
"""
def Atom(t):
    return Prop(None, None, t=t)


"""
class CNF
- denotes one CNF formula
- c: list of CNFClause objs
"""
class CNF:
    def __init__(self, c):
        self.c = c

    def __str__(self):
        return ' & '.join(map(lambda x: str(x), self.c))


"""
class CNFClause
- denotes one CNF clause
- l: list of literals, either str or '!' + str
"""
class CNFClause:
    def __init__(self, l):
        self.l = l

    def __str__(self):
        return '(%s)' % (' | '.join(self.l))
