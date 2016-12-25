from binascii import hexlify
from datetime import datetime
from scanner_data import TLS_1_2, TLS_1_1, TLS_1_0, SSL_3_0, SSL_2_0
from scanner_data import TLS_VERSIONS, TLS_NAME, \
                         TLS_CIPHER_SUITES, SSL_CIPHER_SUITES, \
                         TLS_COMPRESSION_METHODS
from pyx509.pkcs7.asn1_models.decoder_workarounds import decode
from pyx509.pkcs7.asn1_models.X509_certificate import Certificate
from pyx509.pkcs7_models import X509Certificate, PublicKeyInfo
from concurrent.futures.thread import ThreadPoolExecutor
import argparse
import base64
import logging
import os
import socket
import sys
import time


formatter = logging.Formatter('%(message)s')

ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)
ch.setFormatter(formatter)

logger = logging.getLogger("TLSScanner")
logger.setLevel(logging.DEBUG)
logger.addHandler(ch)

default_timeout = 1


def to_hex(num, byte):
    s = ''
    while num:
        s = chr(num % 256) + s
        num /= 256

    if len(s) < byte:
        s = '\x00' * (byte - len(s)) + s

    return s


class TLSBuilder:
    @staticmethod
    def TLSRecord(version, payload):
        packet = '\x16'
        packet += version
        packet += to_hex(len(payload), 2)
        packet += payload
        return packet

    @staticmethod
    def ClientHello(version, ciphers, compressions=[0], extensions=None,
                    no_header=False):
        packet = version
        packet += '\x00' * 32 # random
        packet += '\x00' # session id length

        packet += to_hex(len(ciphers) * 2, 2) # cipher suites length
        for cipher in ciphers:
            packet += to_hex(cipher, 2)

        packet += to_hex(len(compressions), 1) # compression method length
        for compression in compressions:
            packet += to_hex(compression, 1)

        if extensions:
            packet += to_hex(len(extensions), 2)
            packet += extensions

        packet = to_hex(len(packet), 3) + packet
        packet = '\x01' + packet

        if no_header:
            return packet
        return TLSBuilder.TLSRecord(version, packet)


class SecureConn:
    def __init__(self, target, timeout=None):
        if not timeout:
            timeout = default_timeout

        self._s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self._s.settimeout(timeout)
        self._buf = ''
        self.fail = False
        try:
            self._s.connect(target)
        except:
            self.fail = True

    def _get(self, target_len):
        buf_len = len(self._buf)
        while buf_len < target_len:
            rest_len = target_len - buf_len
            recv = self._s.recv(rest_len)
            if not recv:
                break
            self._buf += recv
            buf_len += len(recv)

        ret = self._buf[:target_len]
        self._buf = self._buf[target_len:]
        return ret

    def send(self, packet):
        self._s.send(packet)


class SSLConn(SecureConn):
    def recv(self):
        try:
            length = self._get(2)
            target_len = int(length.encode('hex')[1:], 16)
            body = self._get(target_len)
            return length + body
        except:
            pass


class TLSConn(SecureConn):
    def recv(self):
        if not hasattr(self, '_tls_cache') or self._tls_cache == '':
            self._head = self._get(1)
            self._tls_ver = self._get(2)
            self._tls_len = self._get(2)
            target_len = int(self._tls_len.encode('hex'), 16)
            self._tls_cache = self._get(target_len)

        if self._head == '\x15':
            err_code = self._tls_cache[:]
            self._tls_cache = ''
            return self._head, self._tls_ver, err_code, ''
        elif self._head == '\x16':
            msg_type = self._tls_cache[0]
            length = int(self._tls_cache[1:4].encode('hex'), 16)
            body = self._tls_cache[4:4 + length]
            self._tls_cache = self._tls_cache[4 + length:]
            return self._head, self._tls_ver, msg_type, body
        return '', '', '', ''

    def recv_msg(self, req_type):
        while True:
            head, ver, msg_type, body = self.recv()
            if head != '\x16':
                return False, ''
            elif msg_type == req_type:
                return True, body


class TLSAnalyzer(object):
    def __init__(self):
        self.warnings = []
        self.warning_codes = []
        self.versions = []
        self.ciphers = {
                           TLS_1_2: [],
                           TLS_1_1: [],
                           TLS_1_0: [],
                           SSL_3_0: [],
                           SSL_2_0: []
                       }
        self.dhe_length = 99999
        self.compressions = []
        self.fallback_scsv = False
        self.certchain = []
        self.trust_certs = []

    def check_cipher(self, target, version, cipher_id):
        conn = TLSConn(target)
        if conn.fail:
            return

        packet = TLSBuilder.ClientHello(version, ciphers=[cipher_id])
        try:
            conn.send(packet)
            head, ver, msg_type, body = conn.recv()
        except:
            return

        if head == '\x16' and ver == version:
            logger.debug('[+] ACCEPT CIPHER FOR %s - %s'
                    % (TLS_NAME[version], TLS_CIPHER_SUITES[cipher_id]))
            self.ciphers[version].append(cipher_id)
        else:
            return

        if "_DHE_" in TLS_CIPHER_SUITES[cipher_id]:
            result, body = conn.recv_msg('\x0c')
            if result:
                length_p = int(body.encode('hex')[0:4], 16) * 8
                self.dhe_length = min(self.dhe_length, length_p)

    def check_cipher_ssl(self, target, cipher_id):
        conn = SSLConn(target)
        if conn.fail:
            return

        packet = '\x80\x2c\x01\x00\x02\x00\x03\x00\x00\x00\x20'
        packet += to_hex(cipher_id, 3)
        packet += '\x00' * 32

        try:
            conn.send(packet)
            result = conn.recv()
        except:
            return

        cert_len = int(result[7:9].encode('hex'), 16)
        cipher_len = int(result[9:11].encode('hex'), 16)
        cipher_list = result[13 + cert_len:13 + cert_len + cipher_len]
        for i in range(cipher_len / 3):
            c_id = cipher_list[i * 3: i * 3 + 3]
            if c_id == to_hex(cipher_id, 3):
                logger.debug('[+] ACCEPT CIPHER FOR %s - %s'
                        % (TLS_NAME[SSL_2_0], SSL_CIPHER_SUITES[cipher_id]))
                self.ciphers[SSL_2_0].append(cipher_id)

    def scan_ciphers(self, target):
        for version in TLS_VERSIONS:
            if version == SSL_2_0: continue
            logger.debug('[*] SCAN CIPHER FOR %s' % TLS_NAME[version])
            with ThreadPoolExecutor(max_workers=20) as executor:
                executor.map(lambda x: self.check_cipher(target, version, x),
                             TLS_CIPHER_SUITES.keys())

        logger.debug('[*] SCAN CIPHER FOR %s' % TLS_NAME[SSL_2_0])
        with ThreadPoolExecutor(max_workers=20) as executor:
            executor.map(lambda x: self.check_cipher_ssl(target, x),
                         SSL_CIPHER_SUITES.keys())

        for version in TLS_VERSIONS:
            if self.ciphers[version]:
                self.versions.append(version)

    def check_compression(self, target, version, comp_id):
        conn = TLSConn(target)
        packet = TLSBuilder.ClientHello(version,
                                        ciphers=[self.ciphers[version][-1]],
                                        compressions=[0, comp_id])
        conn.send(packet)
        head, ver, msg_type, body = conn.recv()
        if head != '\x16':
            return

        session_len = int(body[34].encode('hex'), 16)
        comp = body[34 + session_len + 3]
        if comp == to_hex(comp_id, 1):
            self.compressions.append(comp_id)
            name = TLS_COMPRESSION_METHODS[comp_id]
            logger.debug('[+] ACCEPT COMPRESSION FOR %s - %s'
                         % (TLS_NAME[version], name))

    def scan_compressions(self, target):
        for version in TLS_VERSIONS:
            if version not in self.versions or version == SSL_2_0: continue

            logger.debug('[*] SCAN COMPRESSION FOR %s' % TLS_NAME[version])
            with ThreadPoolExecutor(max_workers=20) as executor:
                executor.map(lambda x: self.check_compression(target, version, x),
                             TLS_COMPRESSION_METHODS.keys())

    def scan_certificates(self, target):
        version = self.versions[0]
        if version == SSL_2_0:
            return

        logger.debug('[*] SCAN CERTIFICATE')
        conn = TLSConn(target)
        packet = TLSBuilder.ClientHello(version,
                                        ciphers=[self.ciphers[version][-1]])
        conn.send(packet)
        result, body = conn.recv_msg('\x0b')
        if not result:
            return

        certchain_len = int(body[0:3].encode('hex'), 16)
        cursor = 3
        while cursor < certchain_len:
            cert_len = int(body[cursor:cursor+3].encode('hex'), 16)
            cert = body[cursor+3:cursor+3+cert_len]
            self.certchain.append(X509Certificate(decode(cert, asn1Spec=Certificate())[0]))
            cursor += 3 + cert_len

    def scan_fallback_scsv(self, target):
        if len(self.versions) < 2 or self.versions[1] == SSL_2_0:
            self.fallback_scsv = True
            return

        logger.debug('[*] SCAN FALLBACK_SCSV')
        high = self.versions[0]
        low = self.versions[1]

        conn = TLSConn(target)
        payload = TLSBuilder.ClientHello(low, ciphers=[
                                                self.ciphers[low][0],
                                                0x5600], no_header=True)
        packet = TLSBuilder.TLSRecord(high, payload)
        conn.send(packet)
        head, ver, msg_type, body = conn.recv()
        if head == '\x15' and msg_type[1] == '\x56':
            self.fallback_scsv = True

    def load_trust_certs(self, path):
        with open(path, 'r') as f:
            lines = f.readlines()

        cache = []
        for line in lines:
            if line.startswith('-----BEGIN CERTIFICATE-----'):
                cache = []
            elif line.startswith('-----END CERTIFICATE-----'):
                cert_str = base64.b64decode(''.join(cache))
                sign = X509Certificate(decode(cert_str, asn1Spec=Certificate())
                                              [0]).signature
                self.trust_certs.append(sign)
            else:
                cache.append(line)

    def report(self):
        if SSL_2_0 in self.versions:
            self.warnings.append("[!] SSLv2 ENABLED")
            self.warning_codes.append(1)
        if SSL_3_0 in self.versions:
            self.warnings.append("[!] SSLv3 ENABLED")
            self.warning_codes.append(2)
        if TLS_1_2 not in self.versions:
            self.warnings.append("[!] TLSv1.2 NOT SUPPORTED")
            self.warning_codes.append(3)

        cipher_names = {}
        for version in self.ciphers:
            if version == SSL_2_0:
                cipher_names[version] = map(lambda x: SSL_CIPHER_SUITES[x],
                                            self.ciphers[version])
            else:
                cipher_names[version] = map(lambda x: TLS_CIPHER_SUITES[x],
                                            self.ciphers[version])

        def contains(name, version):
            for cipher_name in cipher_names[version]:
                if name in cipher_name:
                    return True
            return False

        def contains_any(name):
            for version in cipher_names:
                if contains(name, version):
                    return True
            return False

        if contains_any("RC4"):
            self.warnings.append("[!] RC4 CIPHER ENABLED")
            self.warning_codes.append(4)
        if contains_any("MD5"):
            self.warnings.append("[!] MD5 CIPHER ENABLED")
            self.warning_codes.append(5)
        if contains_any("EXP"):
            self.warnings.append("[!] EXPORT LEVEL CIPHER ENABLED")
            self.warning_codes.append(6)
        if contains_any("NULL"):
            self.warnings.append("[!] NULL CIPHER ENABLED")
            self.warning_codes.append(7)
        if contains_any("ANON"):
            self.warnings.append("[!] DH ANON CIPHER ENABLED")
            self.warning_codes.append(8)
        if contains_any("_DES_"):
            self.warnings.append("[!] DES CIPHER ENABLED")
            self.warning_codes.append(9)

        weak_hash = {
            '1.2.840.113549.1.1.5': 'sha1RSA',
            '1.2.840.113549.1.1.4': 'md5RSA',
        }
        for cert in self.certchain:
            name = cert.tbsCertificate.subject

            sign = cert.signature
            sign_algo = cert.tbsCertificate.signature_algorithm
            if sign_algo in weak_hash and sign not in self.trust_certs:
                self.warnings.append("[!] WEAK SIGNATURE - %s(%s)"
                        % (weak_hash[sign_algo], name))
                self.warning_codes.append(10)

            valid_from = cert.tbsCertificate.validity.get_valid_from_as_datetime()
            valid_to = cert.tbsCertificate.validity.get_valid_to_as_datetime()
            now = datetime.now()
            if now < valid_from or now > valid_to:
                self.warnings.append("[!] EXPIRED CERT - %s" % name)
                self.warning_codes.append(11)

            algo_type = cert.tbsCertificate.pub_key_info.algType
            algo_param = cert.tbsCertificate.pub_key_info.key
            if algo_type == PublicKeyInfo.RSA:
                key = hexlify(algo_param["mod"])
            elif algo_type == PublicKeyInfo.DSA:
                key = hexlify(algo_param["p"])
            else:
                key = ''
            size = len(key) * 4
            if size < 2048:
                self.warnings.append("[!] SHORT PUBLIC KEY - %d(%s)" % (size, name))
                self.warning_codes.append(12)


        if SSL_2_0 in self.versions:
            self.warnings.append("[!] VULNERABLE TO DROWN ATTACK")
            self.warning_codes.append(13)
        if contains_any("DSS_EXP") or self.dhe_length < 1024:
            self.warnings.append("[!] VULNERABLE TO LOGJAM ATTACK")
            self.warning_codes.append(14)
        if contains_any("RSA_EXP"):
            self.warnings.append("[!] VULNERABLE TO FREAK ATTACK")
            self.warning_codes.append(15)

        if self.compressions:
            self.warnings.append("[!] VULNERABLE TO CRIME ATTACK")
            self.warning_codes.append(16)

        if SSL_3_0 in self.versions and contains("CBC", SSL_3_0):
            self.warnings.append("[!] VULNERABLE TO POODLE ATTACK")
            self.warning_codes.append(17)

        if not self.fallback_scsv:
            self.warnings.append("[!] NO FALLBACK SCSV")
            self.warning_codes.append(18)

        for warning in self.warnings:
            logger.warning(warning)

        if not len(self.warnings):
            logger.info("[^] NOT VULNERABLE!")


def scan(host, port):
    target = (host, port)

    logger.info("[*] START SCANNING")
    start_time = time.time()

    analyzer = TLSAnalyzer()
    analyzer.load_trust_certs('/etc/ssl/certs/ca-certificates.crt')
    analyzer.scan_ciphers(target)
    if not analyzer.versions:
        logger.warning("[-] SSL/TLS NOT SUPPORTED")
        return [0, ]

    analyzer.scan_certificates(target)
    analyzer.scan_compressions(target)
    analyzer.scan_fallback_scsv(target)
    analyzer.report()

    end_time = time.time()
    logger.info("[*] END SCANNING")
    logger.debug("[*] TOOK %.2f SEC" % (end_time - start_time))
    return list(set(analyzer.warning_codes))


def main():
    argparser = argparse.ArgumentParser(description='TLS/SSL Server Checker')
    argparser.add_argument('-v', type=int, choices=[0, 1, 2, 3], dest='verbose', help='verbose level')
    argparser.add_argument('-o', dest='output', help='name of output files')
    group = argparser.add_mutually_exclusive_group(required=True)
    group.add_argument('-a', dest='address', help='address to check')
    group.add_argument('-r', dest='filename', help='input file')
    args = argparser.parse_args()

    if args.verbose == 1:
        ch.setLevel(logging.INFO)
    elif args.verbose == 2:
        ch.setLevel(logging.WARNING)
    elif args.verbose == 3:
        ch.setLevel(logging.ERROR)

    addrs = []
    if args.address:
        addrs.append(args.address)
    else:
        if not os.path.exists(args.filename):
            print('tls-scanner.py: cannot find file %s' % args.filename)
            exit(1)

        with open(args.filename, 'r') as f:
            addrs = map(lambda x: x.strip(), f.readlines())


    for addr in addrs:
        s = addr.split(':')
        if len(s) != 2 or not s[1].isdigit():
            continue

        host, port = s[0], int(s[1])
        codes = [-1, ]
        for i in range(3):
            try:
                codes = scan(host, port)
                break
            except Exception as e:
                print(str(e))

        codes_str = ",".join(map(str, sorted(codes)))
        log = "%s:%s-%s" % (host, port, codes_str)
        logger.error(log)

        if args.output:
            f_w = open(args.output, 'a')
            f_w.write(log + '\n')
            f_w.close()

if __name__ == "__main__":
    main()
