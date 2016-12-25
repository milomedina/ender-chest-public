from parser import parse_data
from core import load_data, set_config, train
import argparse
import os


def main():
    parser = argparse.ArgumentParser(description='do symbolic regression')
    parser.add_argument('train_file', help='file to train')
    parser.add_argument('-i', type=int, default=100, help='number of iteration')
    parser.add_argument('-p', type=int, default=1000, help='population size')
    parser.add_argument('-v', action='store_true', help='print detail information')
    parser.add_argument('-r', action='store_true', help='recover from dump')
    args = parser.parse_args()

    if not os.path.isfile(args.train_file):
        print('main: train file not exist')
        exit(1)

    with open(args.train_file, 'r') as f:
        lines = f.readlines()
    data, label = parse_data(lines)

    load_data(data, label)
    set_config({
        'ITER_NUM': args.i,
        'POP_SIZE': args.p,
        'PRESERVE_NUM': args.i // 2,
        'CONST': [0, 2, 2.5, 3, 4, 5, 10],
        'PROB_OP': {'+': 2, '-': 2, '*': 2, '/': 2, '^': 0.5, '~': 3,
                    'abs': 0.5, 'sin': 1.5, 'cos': 1.5, 'tan': 1,
                    'asin': 0.5, 'acos': 0.5, 'atan': 0.5,
                    'sinh': 0.5, 'cosh': 0.5, 'tanh': 0.5,
                    'exp': 2, 'sqrt': 2, 'log': 2},
        'VERBOSE': args.v
    })
    result = train(args.r)

    print('MSE: %s' % result[1])
    print('EXPR (postfix): %s' % result[0].to_postfix())
    print('EXPR (infix): %s' % result[0])


if __name__ == '__main__':
    main()
