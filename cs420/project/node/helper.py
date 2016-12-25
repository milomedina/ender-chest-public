def _ast_indent(s):
    return '\n'.join(map(lambda x: '    ' + x, s.split('\n')))
