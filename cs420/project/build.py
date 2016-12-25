import os


_FILE_NAME = [
    "program.py",
    "declaration.py",
    "identifier.py",
    "function.py",
    "param.py",
    "stmt.py",
    "compound_stmt.py",
    "assign_stmt.py",
    "call_stmt.py",
    "ret_stmt.py",
    "while_stmt.py",
    "dowhile_stmt.py",
    "for_stmt.py",
    "if_stmt.py",
    "switch_stmt.py",
    "case_list.py",
    "num_case.py",
    "default_case.py",
    "null_stmt.py",
    "expr.py",
    "unop_expr.py",
    "binop_expr.py",
    "call_expr.py",
    "num_expr.py",
    "id_expr.py",

    "helper.py",
    "symtab.py",
]
ROOT_PATH = os.path.abspath(os.path.dirname(__file__))
NODE_PATH = os.path.join(ROOT_PATH, 'node')


def generate(path):
    if not os.path.exists(path):
        return False

    sources = ['# CS420 NODE STRUCT FILE - AUTO GENERATED #\n', ]
    for name in _FILE_NAME:
        with open(os.path.join(path, name), 'r') as f:
            sources += ['\n\n', ]
            sources += ['# FILE FROM: %s\n' % name, ]
            sources += f.readlines()
    sources += ['\n\n# END OF AUTO GENERATED FILE #\n', ]

    with open(os.path.join(path, '_struct.py'), 'w') as f:
        for line in sources:
            f.write(line)
    return True

if __name__ == '__main__':
    generate(NODE_PATH)
