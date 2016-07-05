import re
import sys
import os.path

inf = 10000000000

def getm(matrix, i, j):
    if i < 0 or j < 0:
        return -inf
    elif len(matrix) > i and len(matrix[i]) > j:
        return matrix[i][j]
    return inf

def setm(matrix, i, j, value):
    matrix[i][j] = value

def extract(matrix):
    [x, y] = [0, 0]
    while True:
        right = getm(matrix, x, y+1)
        top = getm(matrix, x+1, y)
        if right == top and top == inf:
            setm(matrix, x, y, inf)
            return
        elif right < top:
            setm(matrix, x, y, right)
            y += 1
        elif right > top:
            setm(matrix, x, y, top)
            x += 1

def insert(matrix, elem):
    [x, y] = [len(matrix) - 1, len(matrix[0]) - 1]
    if getm(matrix, x, y) != inf:
        matrix.append([inf] * len(matrix[0]))
        x += 1

    while True:
        left = getm(matrix, x, y-1)
        bottom = getm(matrix, x-1, y)
        if left > elem and y > 0 and left > bottom:
            setm(matrix, x, y, left)
            y -= 1
        elif bottom > elem and x > 0:
            setm(matrix, x, y, bottom)
            x -= 1
        else:
            setm(matrix, x, y, elem)
            return

def reprm(matrix):
    s = []
    for i in range(len(matrix)):
        s.append(" ".join(map(lambda x: "" if x == inf else str(x), matrix[i])).strip())
    return "\n".join(s)

def main():
    argv = sys.argv
    if len(argv) < 2:
        print "usage: python pa1.py input.txt"
        exit(1)

    filename = argv[1]
    if not os.path.isfile(filename):
        print "no such file: %s" % filename
        exit(1)

    filere = re.match(r'input_([0-9]+)\.txt', filename)
    if not filere:
        print "invalid file name format: %s" % filename
        exit(1)
    fileno = filere.group(1)

    f = open(argv[1], "r")
    info = f.readline()
    [n, m, op] = map(lambda x: int(x), info.split(" "))

    ops = []
    for i in range(op):
        ops.append(f.readline().strip())

    matrix = []
    for i in range(m):
        l = map(lambda x: int(x) if x != '#' else inf,
                f.readline().strip().split(" "))
        matrix.append(l)
    f.close()

    for op in ops:
        if op[0] == 'E':
            extract(matrix)
        elif op[0] == 'I':
            insert(matrix, int(op.split(" ")[1]))
        else:
            print "unsupported operation: %s" % op

    out = open("output_%s.txt" % fileno, 'w')
    out.write(reprm(matrix))
    out.close()


if __name__ == "__main__":
    main()
