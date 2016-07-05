import sys


INF = 1000000000000000000


def toint(l):
    try:
        return map(lambda x: int(x), l)
    except:
        print '------------------ EXCEPTION? -------------------'
        print 'The code could always use more input, EXCEPT THIS'
        print '----------- https://playoverwatch.com -----------'
        exit(1)

def main():
    input_fn = sys.argv[1]
    output_fn = input_fn.replace('input', 'output')

    with open(input_fn, 'r') as f:
        [n, P] = toint(f.readline().strip().split(' '))
        L = [0] + toint(f.readline().strip().split(' '))

    C = [[0 for i in range(n+1)] for j in range(n+1)]
    for i in range(1,n+1):
        C[i][i] =  P - L[i]
        for j in range(i+1,n+1):
            C[i][j] = C[i][j-1] - 1 - L[j]
    C = [[INF if x < 0 else x for x in l] for l in C]

    R = [0 for i in range(n+1)]
    for i in range(1,n+1):
        R[i] = min(map(lambda j: R[j-1] + C[j][i], range(1,i+1)))

    with open(output_fn, 'w') as f:
        f.write(str(R[n]))

if __name__ == "__main__":
    main()
