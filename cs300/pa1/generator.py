import random
inf = 100000000000
array_size = 100
instr_size = 1000

def getm(matrix, i, j):
    if i < 0 or j < 0:
        return -inf
    elif len(matrix) > i and len(matrix[i]) > j:
        return matrix[i][j]
    return inf

def reprm(matrix):
    s = []
    for i in range(len(matrix)):
        s.append(" ".join(map(lambda x: "#" if x == inf else str(x), matrix[i])))
    return "\n".join(s)


num_list = {}
max_int = 0
matrix = [[inf for i in range(array_size)] for j in range(array_size)]

prev_len = array_size
for i in range(array_size):
    row_lb = prev_len*2/3
    row_len = random.randint(row_lb if row_lb else 1, prev_len)
    prev_len = row_len
    for j in range(row_len):
        lb = max(getm(matrix, i, j-1), getm(matrix, i-1, j))
        if lb < 0:
            lb = 1
        while True:
            r = random.randint(lb, lb+100)
            if r not in num_list:
                matrix[i][j] = r
                num_list[r] = 1
                max_int = max(max_int, r)
                break

f = open('input_5.txt', 'w')
f.write('%d %d %d\n' % (array_size, array_size, instr_size))

for i in range(instr_size):
    insert = random.randint(0, 5)
    if insert:
        while True:
            r = random.randint(1, 2*max_int)
            if r not in num_list:
                f.write('I %d\n' % r)
                num_list[r] = 1
                break
    else:
        f.write('E\n')

f.write(reprm(matrix))
f.close()
