import subprocess

def exec_minisat(cnfobj):
    variables = {}
    count = 0
    for c in cnfobj.c:
        for l in c.l:
            v = l[2:] if l[0] == '-' else l
            if v not in variables:
                count += 1
                variables[v] = count

    f = open('input.txt', 'w')
    f.write('p cnf %s %s\n' % (count, len(cnfobj.c )))
    for c in cnfobj.c:
        for l in c.l:
            if l[0] == '-':
                f.write('-%s ' % variables[l[2:]])
            else:
                f.write('%s ' % variables[l])
        f.write('0\n')
    f.close()

    with open('log.txt', 'w') as l:
        p = subprocess.call(['./minisat','input.txt', 'output.txt'], stdout=l)
