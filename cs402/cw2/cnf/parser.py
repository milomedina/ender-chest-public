from core import Prop, Atom


def _parse(tokens):
    f = tokens[0]
    if f in ['&', '>', '<', '=', '|']:
        [l, rem] = _parse(tokens[1:])
        [r, rem] = _parse(rem)
        return [Prop(f, l, r), rem]
    elif f == '-':
        [l, rem] = _parse(tokens[1:])
        return [Prop(f, l), rem]
    return [Atom(f), tokens[1:]]

def parse(string):
    tokens = string.split(' ')
    [expr, rem] = _parse(tokens)
    return expr


if __name__ == '__main__':
    print parse('> & - p q & p > r q')
