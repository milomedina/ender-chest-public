from core import Prop, Atom, CNF, CNFClause

"""
def _rmImpEQ: Prop -> Prop
- remove implication, reverse implication, equivalence from given prop obj
- return new prop obj
"""
def _rmImpEq(prop):
    # base case
    if not prop or not prop.op:
        return prop

    l = _rmImpEq(prop.l)
    r = _rmImpEq(prop.r)
    if prop.op == '>': # l > r --> -l | r
        return Prop('|', Prop('-', l), r)
    elif prop.op == '<': # l < r --> -r | l
        return Prop('|', Prop('-', r), l)
    elif prop.op == '=': # l = r --> (-l | r) & (-l | r)
        return Prop('&', Prop('|', Prop('-', l), r),
                         Prop('|', Prop('-', r), l))
    else:
        return Prop(prop.op, l, r)


"""
def _toNNF: Prop -> Prop
- get prop obj that only consist and, or and not
- produce NNF form of prop obj
"""
def _toNNF(prop):
    # base case
    if not prop or not prop.op:
        return prop

    if prop.op == '-': # -(a | b), -(a & b), -(-a)
        if prop.l.op == '-': # -(-a) --> a
            return _toNNF(prop.l.l)
        elif prop.l.op == None: # -a (terminal)
            return prop

        l = prop.l.l
        r = prop.l.r
        op = '&' if prop.l.op == '|' else '|'
        return _toNNF(Prop(op, Prop('-', l), Prop('-', r)))
    else: # (a | b), (a & b)
        l = _toNNF(prop.l)
        r = _toNNF(prop.r)
        return Prop(prop.op, l, r)

"""
def _distr: Prop -> Prop
- get CNF form of prop l, r
- produce CNF form for l | r
"""
def _distr(l, r):
    if l and l.op == '&':
        return Prop('&', _distr(l.l, r), _distr(l.r, r))
    elif r and r.op == '&':
        return Prop('&', _distr(l, r.l), _distr(l, r.r))
    else:
        return Prop('|', l, r)

"""
def _toCNF: Prop -> Prop
- get NNF form of prop obj
- produce CNF form of prop obj
"""
def _toCNF(prop):
    # base case
    if not prop or not prop.op or prop.op == '-':
        return prop

    l = _toCNF(prop.l)
    r = _toCNF(prop.r)
    if prop.op == '&':
        return Prop('&', l, r)
    else:
        return _distr(l, r)

"""
def _extClause: Prop -> list(Prop)
- get CNF form of prop obj
- produce list of clause prop objs
"""
def _extClause(prop):
    if not prop:
        return []
    elif not prop.op or prop.op == '-':
        return [prop]
    elif prop.op == '|':
        return [prop]
    else:
        return _extClause(prop.l) + _extClause(prop.r)

"""
def _extLiterial: Prop -> list(str)
- get a clause of prop obj
- produce list of literials
"""
def _extLit(prop):
    if not prop:
        return []
    elif not prop.op:
        return [prop.t]
    elif prop.op == '-':
        return ['- %s' % prop.l.t]
    else:
        return _extLit(prop.l) + _extLit(prop.r)

"""
def toCNF: Prop -> Prop
- get any form of prop obj
- produce CNF form of prop obj
"""
def toCNF(prop):
    return _toCNF(_toNNF(_rmImpEq(prop)))

"""
def toCNFObj: Prop -> CNF
- get CNF form of prop ojb
- produce CNF obj
"""
def toCNFObj(prop):
    clauses = []
    for clause in _extClause(prop):
        clauses.append(CNFClause(_extLit(clause)))
    return CNF(clauses)


if __name__ == '__main__':
    prop1 = Prop('>', Prop('&', Prop('-', Atom('p')), Atom('q')),
                      Prop('&', Atom('p'), Prop('>', Atom('r'), Atom('q'))))
    print '%s --> %s' % (prop1, toCNFObj(toCNF(prop1)))

    prop2 = Prop('-', Prop('=', Atom('p'), Atom('p')))
    print prop2, _rmImpEq(prop2), _toNNF(_rmImpEq(prop2))
