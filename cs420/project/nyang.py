from minicyacc import lexer, parser
from logging.config import dictConfig
import argparse
import pprint
import os
import logging


dictConfig(
{
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            'format': '%(asctime)s [%(levelname)s] %(message)s',
        },
        'parser': {
            'format': '%(message)s',
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'level': 'DEBUG',
            'formatter': 'standard',
        },
        'parser': {
            'class': 'logging.FileHandler',
            'level': 'DEBUG',
            'filename': 'parse.txt',
            'mode': 'w',
        },
    },
    'loggers': {
        'nyang': {
            'handlers': ['console', ],
            'level': 'DEBUG',
        },
        'nyang.parser': {
            'handlers': ['parser', ],
            'level': 'DEBUG',
            'propagate': False,
        },
    }
})
main_log = logging.getLogger('nyang')
parser_log = logging.getLogger('nyang.parser')


def parse(file_path):
    with open(file_path, 'r') as f:
        code = f.read()
    return parser.parse(code, lexer=lexer, debug=parser_log)


def save_ast(ast):
    ast_str = str(ast)
    with open('tree.txt', 'w') as f:
        f.write(ast_str)


def save_symtab(symtab):
    symtab_str = str(symtab)
    with open('table.txt', 'w') as f:
        f.write(symtab_str)


def main():
    argparser = argparse.ArgumentParser(description='MiniC AST Builder')
    argparser.add_argument('file_path', help='a mini-c source file path')
    argparser.add_argument('-q', dest='quiet', action='store_true')

    args = argparser.parse_args()

    if args.quiet:
        main_log.setLevel('ERROR')

    main_log.info('main: set file=%s' % args.file_path)
    if not os.path.exists(args.file_path):
        main_log.error('main: no such file')
        exit(1)

    try:
        main_log.debug('parsing: start')
        ast = parse(args.file_path)
        main_log.debug('parsing: done')
        main_log.info('parsing: saved in parse.txt')
    except SyntaxError:
        main_log.error('parsing: bad syntax')
        exit(1)

    save_ast(ast)
    main_log.info('ast: saved in tree.txt')

    main_log.debug('symtab: start')
    symtab = ast.symtab()[0][0]
    main_log.debug('symtab: done')

    save_symtab(symtab)
    main_log.info('symtab: saved in table.txt')


if __name__ == '__main__':
    main()
