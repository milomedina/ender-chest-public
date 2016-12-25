from core import CONFIG, load_data, calc_mse
from parser import parse_expr, parse_data
import argparse
import os


def main():
    parser = argparse.ArgumentParser(description='print MSE of approximated solution')
    parser.add_argument('expr', help='the solution expr (as postfix)')
    parser.add_argument('test_file', help='file to calculate MSE')
    args = parser.parse_args()

    is_valid, expr = parse_expr(args.expr)
    if not is_valid:
        print('parse: invalid expression')
        exit(1)

    if not os.path.isfile(args.test_file):
        print('main: test file not exist')
        exit(1)

    with open(args.test_file, 'r') as f:
        lines = f.readlines()
    data, label = parse_data(lines)
    load_data(data, label)

    try:
        print(calc_mse(expr))
    except:
        print('main: math error')


if __name__ == '__main__':
    main()
