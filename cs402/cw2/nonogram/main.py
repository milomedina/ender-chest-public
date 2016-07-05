from core import Prop, Atom
from minisat import exec_minisat
from cnflize import toCNF, toCNFObj
from datetime import datetime
import os
import sys


def make_conf(l, idx, n):
    if not l:
        return [map(lambda x: [0, 0], range(idx, n))]

    elem = l[0]
    if idx + elem > n:
        return []

    results = []
    for offset in range(n-idx-elem+1):
        start = idx + offset
        end = start + elem - 1

        elem_id = len(l)
        before = map(lambda x: [0, 0], range(idx, start))
        block = map(lambda x: [1, elem_id], range(start, end+1))
        pad = [[0, 0]] if end+1 < n else []
        childs = make_conf(l[1:], end+2, n)

        for child in childs:
            results.append(before+block+pad+child)
    return results


def merge_conf(confs, n):
    result = [-1 for x in range(n)]
    for i in range(n):
        cell = [-1, 0]
        for conf in confs:
            if cell[0] == -1:
                cell = conf[i]
            elif cell != conf[i]:
                cell = [-100, 0]
        result[i] = -1 if cell[0] == -100 else cell[0]
    return result


def preprocess(board, row_confs, col_confs, rows, cols):
    nrows, ncols = len(board), len(board[0])
    for i in range(nrows):
        row = merge_conf(row_confs[i], ncols)
        for j in range(ncols):
            if board[i][j] == -1:
                board[i][j] = row[j]

    for j in range(ncols):
        col = merge_conf(col_confs[j], nrows)
        for i in range(nrows):
            if board[i][j] == -1:
                board[i][j] = col[i]

    new_row_confs = []
    for i in range(nrows):
        row_conf = []
        for conf in row_confs[i]:
            ok = True
            for j in range(ncols):
                if (board[i][j] != -1 and board[i][j] != conf[j][0]):
                    ok = False
            if ok:
                row_conf.append(conf)

        if not row_conf:
            print 'NO SOLUTION'
            exit(1)
        new_row_confs.append(row_conf)

    new_col_confs = []
    for j in range(ncols):
        col_conf = []
        for conf in col_confs[j]:
            ok = True
            for i in range(nrows):
                if (board[i][j] != -1 and board[i][j] != conf[i][0]):
                    ok = False
            if ok:
                col_conf.append(conf)

        if not col_conf:
            print 'NO SOLUTION'
            exit(1)
        new_col_confs.append(col_conf)

    return [board, new_row_confs, new_col_confs]


def to_sat_row(board, row_conf, i, ncols):
    formula = None
    for conf in row_conf:
        clause = None
        for j in range(ncols):
            if board[i][j] != -1:
                continue
            lit = Atom('%s,%s' % (i, j))
            lit = lit if conf[j][0] else Prop('-', lit)
            clause =  Prop('&', clause, lit) if clause else lit
        formula = Prop('|', formula, clause) if formula else clause
    return toCNF(formula)


def to_sat_col(board, col_conf, j, nrows):
    formula = None
    for conf in col_conf:
        clause = None
        for i in range(nrows):
            if board[i][j] != -1:
                continue
            lit = Atom('%s,%s' % (i, j))
            lit = lit if conf[i][0] else Prop('-', lit)
            clause =  Prop('&', clause, lit) if clause else lit
        formula = Prop('|', formula, clause) if formula else clause
    return toCNF(formula)


def main():
    if len(sys.argv) < 2:
        print "usage: python main.py input.txt"
        exit(1)

    filename = sys.argv[1]
    if not os.path.isfile(filename):
        print "no such file: %s" % filename
        exit(1)

    # before = datetime.now()


    """ FILE READ """
    f = open(filename, 'r')
    nrows = int(f.readline().strip())
    ncols = int(f.readline().strip())

    rows = []
    for i in range(nrows):
        rows.append(map(lambda x: int(x), f.readline().strip().split(' ')))

    cols = []
    for j in range(ncols):
        cols.append(map(lambda x: int(x), f.readline().strip().split(' ' )))

    f.close()


    """ PREPROCESS """
    board = [[-1 for j in range(ncols)] for i in range(nrows)]
    row_confs, col_confs = [], []

    for i in range(nrows):
        row_confs.append(make_conf(rows[i], 0, ncols))
    for j in range(ncols):
        col_confs.append(make_conf(cols[j], 0, nrows))

    while True:
        old_board = [[board[i][j] for j in range(ncols)] for i in range(nrows)]
        [board, row_confs, col_confs] = \
                preprocess(board, row_confs, col_confs, rows, cols)

        same = True
        for i in range(nrows):
            for j in range(ncols):
                if old_board[i][j] != board[i][j]:
                    same = False
        if same:
            break


    """ CONVERSION TO SAT """
    form = Atom('0')
    for i in range(nrows):
        form = Prop('&', form, to_sat_row(board, row_confs[i], i, ncols))

    for j in range(ncols):
        form = Prop('&', form, to_sat_col(board, col_confs[j], j, nrows))

    cnfobj = toCNFObj(form)


    """ EXECUTE AND READ """
    exec_minisat(cnfobj)

    f = open('output.txt', 'r')
    if f.readline().strip() != 'SAT':
        print 'NO SOLUTION'
        exit(0)
    conf = f.readline().strip().split(' ')
    f.close()


    """ PRINT """
    count, i, j = 1, 0, 0
    while i < nrows:
        if board[i][j] == -1:
            board[i][j] = 0 if conf[count][0] == '-' else 1
            count += 1
        j += 1
        if j == ncols:
            i += 1; j = 0

    for i in range(nrows):
        print " ".join(map(lambda x: '#' if x else '-', board[i]))

    # after = datetime.now()
    # print 'TOOK %s sec' % (after - before).seconds


if __name__ == '__main__':
    main()
