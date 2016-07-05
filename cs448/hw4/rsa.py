import random

def prepation(p, q):
    n = p * q
    e = pi_n = (p - 1) * (q - 1)
    while gcd(pi_n, e) != 1:
        e = random.randint(2, pi_n - 1)
    d = modinv(e, pi_n)
    return n, e, d

def encryption(M, e, n):
    return modpow(M, e, n)

def decryption(C, d, n):
    return modpow(C, d, n)

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

def test(p, q, M):
    print("Test for p=" + str(p) + ", q=" + str(q) + ", M=" + str(M))

    n, e, d = prepation(p, q)
    print("- Keys: e=" + str(e) + ", d=" + str(d))

    pi_n = (p - 1) * (q - 1)
    print("-- pi(n)=" + str(pi_n) + ", gcd(pi(n), e)=" + str(gcd(pi_n, e)) + ", e*d mod pi(n)=" + str(e * d % pi_n))
	
    C = encryption(M, e, n)
    print("- Encrypted: C=" + str(C))
    
    D = decryption(C, d, n)
    print("- Decrypted: D=" + str(D))

    if M == D:
        print("= Success (i.e M = D)")
    else:
        print("= Fail (i.e M != D)")
    print()


test(2357, 2551, 1234)
test(885320963, 238855417, 1234567)
