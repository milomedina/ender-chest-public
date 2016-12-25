from struct import Vertex, Graph


# Parse the datafile
def parse(file_name):
    dimension = 0
    vertex_list = []

    with open(file_name, 'r') as f:
        lines = f.readlines()
        lines_n = len(lines)

    for i in range(lines_n):
        l = lines[i].strip()
        if l.startswith('DIMENSION'):
            dimension = int(list(map(lambda x: x.strip(), l.split(':')))[1])
        elif l.startswith('NODE_COORD_SECTION'):
            lines = lines[i+1:]
            lines_n = len(lines)
            break

    for i in range(lines_n):
        l = lines[i].strip().split(' ')
        if l[0] == 'EOF':
            break

        if len(l) != 3:
            continue

        n, x, y = l
        vertex_list.append(Vertex(int(n), int(float(x)), int(float(y))))

    if dimension != len(vertex_list):
        return None

    return Graph(vertex_list)

