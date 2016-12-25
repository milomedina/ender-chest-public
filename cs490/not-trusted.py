from OpenSSL import crypto
from datetime import datetime
from requests.exceptions import Timeout, ConnectionError, SSLError
import argparse
import os
import ssl
import requests


CA_CERTS = "/etc/ssl/certs/ca-certificates.crt"
ERR_NONE = 0
ERR_SELF_SIGNED = 1
ERR_HOST_NOT_MATCH = 2
ERR_EXPIRED = 4
ERR_TIMEOUT = 8
ERR_UNKNOWN = 16

ERR_STR = {
    ERR_SELF_SIGNED: 'self signed',
    ERR_HOST_NOT_MATCH: 'hostname not match',
    ERR_EXPIRED: 'expired',
}


def inspect(host, port):
    try:
        r = requests.get('https://%s:%s' % (host, port), timeout=2)
    except SSLError as e:
        errmsg = str(e)

        # CHECK ERR_HOST_NOT_MATCH
        if errmsg.startswith('hostname'):
            return ERR_HOST_NOT_MATCH

        try:
            raw_cert = ssl.get_server_certificate((host, port))
        except:
            return ERR_UNKNOWN

        x509 = crypto.load_certificate(crypto.FILETYPE_PEM, raw_cert)

        # CHECK ERR_EXPIRED
        now = datetime.now()
        not_after = datetime.strptime(x509.get_notAfter().decode('utf-8'),
                                      "%Y%m%d%H%M%SZ")
        not_before = datetime.strptime(x509.get_notBefore().decode('utf-8'),
                                       "%Y%m%d%H%M%SZ")
        if now > not_after or now < not_before:
            return ERR_EXPIRED

        # otherwise ERR_SELF_SIGNED
        return ERR_SELF_SIGNED
    except ConnectionError as e:
        return ERR_TIMEOUT
    except Timeout as e:
        return ERR_TIMEOUT
    except:
        return ERR_UNKNOWN
    return ERR_NONE


def main():
    argparser = argparse.ArgumentParser(description='TLS/SSL Cert Checker')
    group = argparser.add_mutually_exclusive_group(required=True)
    group.add_argument('-a', dest='address', help='address to check')
    group.add_argument('-r', dest='filename', help='input file')
    args = argparser.parse_args()

    addrs = []
    if args.address:
        addrs.append(args.address)
    else:
        if not os.path.exists(args.filename):
            print('not-trusted.py: cannot find file %s' % args.filename)
            exit(1)

        with open(args.filename, 'r') as f:
            addrs = map(lambda x: x.strip(), f.readlines())

    total, connected, valid = 0, 0, 0
    error = {
        ERR_SELF_SIGNED: 0,
        ERR_HOST_NOT_MATCH: 0,
        ERR_EXPIRED: 0,
    }

    for addr in addrs:
        s = addr.split(':')
        if len(s) != 2 or not s[1].isdigit():
            continue

        host, port = s[0], int(s[1])
        result = inspect(host, port)

        total += 1
        if result == ERR_TIMEOUT:
            print('? %s: connection error' % addr)
            continue

        if result == ERR_UNKNOWN:
            print('? %s: unknown exception' % addr)
            continue

        connected += 1
        if result == ERR_NONE:
            valid += 1
            print('+ %s: valid certificate' % addr)
        else:
            error[result] += 1
            print('- %s: invalid cert - %s' % (addr, ERR_STR[result]))

    print('\n== SCAN RESULT ==')
    print('Total             : %d' % total)
    print('- Connected       : %d' % connected)
    print('-- Valid          : %d' % valid)
    print('-- Error          : %d' % sum(error.values()))
    print('--- Host NOT Match: %d' % error[ERR_HOST_NOT_MATCH])
    print('--- Expired       : %d' % error[ERR_EXPIRED])
    print('--- Self Signed   : %d' % error[ERR_SELF_SIGNED])


if __name__ == '__main__':
    main()
