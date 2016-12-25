from functools import reduce
import math
import random


# maximum cost when invalid tour
MAX_COST = 100000000000000000000000


class Vertex:
    """ represent a vertex - vertex no, x coord, y coord """
    def __init__(self, n, x, y):
        self._n = n
        self._x = x
        self._y = y

    def get_coord(self):
        return (self._x, self._y)

    def __str__(self):
        return 'Vertex %s (%s, %s)' % (self._n, self._x, self._y)


class Graph:
    """ represent a graph - simple list of vertex """
    def __init__(self, vertex_list):
        self._vertex_list = vertex_list
        self._vertex_num = len(vertex_list)
        self._dist_cache = {}

    def vertex_num(self):
        return self._vertex_num

    def vertex_list(self):
        return self._vertex_list

    # get distance between vertex index i and j
    def dist(self, i, j):
        if i < 0 or j < 0:
            return 0

        if (i, j) in self._dist_cache:
            return self._dist_cache[(i, j)]

        c1 = self._vertex_list[i].get_coord()
        c2 = self._vertex_list[j].get_coord()
        d = math.sqrt((c1[0] - c2[0]) ** 2 + (c1[1] - c2[1]) ** 2)
        self._dist_cache[(i, j)] = d

        if len(self._dist_cache) == 100000:
            self._dist_cache.popitem()
        return d

    # get travel cost by vertex order
    def travel(self, order):
        if not order:
            return MAX_COST

        if type(order[0]) is list:
            order = list(reduce(lambda x, y: x+y, order))

        if len(order) != self._vertex_num:
            return -1

        cost = 0
        for i in range(self._vertex_num):
            cost += self.dist(order[i-1], order[i])
        return cost

    def __str__(self):
        return 'Graph (Vertex: %s)' % self._vertex_num

