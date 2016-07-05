from parser import parse
from core import Prop
from cnflize import toCNF, toCNFObj
from minisat import exec_minisat
import sys

if len(sys.argv) < 2:
    print "usage: python main.py formula"
    exit(1)

formula = parse(sys.argv[1])
cnf = toCNF(formula)
cnfobj = toCNFObj(cnf)

neg = Prop('-', formula)
negcnfobj = toCNFObj(toCNF(neg))

exec_minisat(negcnfobj)

f = open('output.txt', 'r')
result = 'Not Valid' if f.readline().strip() == 'SAT' else 'Valid'

print cnf.str2prefix()
print cnfobj
print result
