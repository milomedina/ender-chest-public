from math import ceil, sqrt
import random

def shank(p, a, b):
    m = ceil(sqrt(p - 1))
    t = modpow(a, m, p)
    
    alist = []
    blist = []
    for i in range(0, m):
        alist.append((i, modpow(t, i, p)))
        blist.append((i, b * modinv(modpow(a, i, p), p) % p))
    alist.sort(key=lambda x:x[1])
    blist.sort(key=lambda x:x[1])

    ap = bp = 0
    while ap < m - 1 or bp < m - 1:
        if alist[ap][1] < blist[bp][1] and ap < m - 1:
            ap += 1
        elif alist[ap][1] > blist[bp][1] and bp < m - 1:
            bp += 1
        elif alist[ap][1] == blist[bp][1]:
            return m * alist[ap][0] + blist[bp][0]
        else:
            raise Exception("No Match")

def gcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a
    
def modinv(a, N):
    x1, x2, x3 = 1, 0, N
    y1, y2, y3 = 0, 1, a
    
    while y3 > 1:
        q = x3 // y3
        t1, t2, t3 = x1 - q * y1, x2 -  q * y2, x3 - q * y3
        x1, x2, x3 = y1, y2, y3
        y1, y2, y3 = t1, t2, t3

    if y3 == 0:
        raise Exception("No Inverse")
    return y2 % N

def modpow(a, b, N):
    x = 1
    while b > 0:
        if b & 1 == 1:
            x = (x * a) % N
        a = (a * a) % N
        b >>= 1
    return x % N

def test(p, a, b):
    print("Test for p=" + str(p) + ", a=" + str(a) + ", b=" + str(b))
    
    x = shank(p, a, b)
    print("- x = " + str(x))

    bp = modpow(a, x, p)
    print("- b' = a^x mod p = " + str(bp))

    if b == bp:
        print("= Success (i.e b' = b)")
    else:
        print("= Fail (i.e b' != b)")
    print()

test(809, 3, 500)
