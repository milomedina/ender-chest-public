import argparse
import math
import random
import sys


class Vertex:
    def __init__(self, n, x, y):
        self._n = n
        self._x = x
        self._y = y

    def get_coord(self):
        return (self._x, self._y)

    def __str__(self):
        return 'Vertex %s (%s, %s)' % (self._n, self._x, self._y)


class Graph:
    def __init__(self, vertex_list):
        self._vertex_list = vertex_list
        self._vertex_num = len(vertex_list)

    def vertex_num(self):
        return self._vertex_num

    def vertex_list(self):
        return self._vertex_list

    def dist(self, i, j):
        if i < 0 or j < 0:
            return 0

        c1 = self._vertex_list[i].get_coord()
        c2 = self._vertex_list[j].get_coord()
        return math.sqrt((c1[0] - c2[0]) ** 2 + (c1[1] - c2[1]) ** 2)

    def travel(self, order):
        if not order:
            return 1000000000000000000000

        if len(order) != self._vertex_num:
            return -1

        cost = 0
        for i in range(self._vertex_num):
            cost += self.dist(order[i-1], order[i])
        return cost

    def __str__(self):
        return 'Graph (Vertex: %s)' % self._vertex_num


def _parse(file_name):
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
        vertex_list.append(Vertex(int(n), float(x), float(y)))

    if dimension != len(vertex_list):
        return None
    return Graph(vertex_list)


def _parse_tour(tour_file_name):
    dimension = 0
    idx_list = []

    with open(tour_file_name, 'r') as f:
        lines = f.readlines()
        lines_n = len(lines)

    for i in range(lines_n):
        l = lines[i].strip()
        if l.startswith('DIMENSION'):
            dimension = int(list(map(lambda x: x.strip(), l.split(':')))[1])
        elif l.startswith('TOUR_SECTION'):
            lines = lines[i+1:]
            lines_n = len(lines)
            break

    for i in range(lines_n):
        l = lines[i].strip().split(' ')
        if l[0] == 'EOF' or l[0] == '-1':
            break

        if len(l) != 1:
            continue

        idx_list.append(int(l[0]) - 1)

    if dimension != len(idx_list):
        return None

    return idx_list


def main():
    parser = argparse.ArgumentParser(description='Get cost of solution of given TSP tour')
    parser.add_argument('file_name', help='graph data file')
    parser.add_argument('tour_file_name', help='TSP tour data file')
    args = parser.parse_args()

    graph = _parse(args.file_name)
    if not graph:
        print('- invalid graph file')
        exit(1)

    tour = _parse_tour(args.tour_file_name)
    if not tour:
        print('- invalid graph tour file')
        exit(1)

    print('Optimal Tour Cost: %s' % graph.travel(tour))

if __name__ == '__main__':
    main()

