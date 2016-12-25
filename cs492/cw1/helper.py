from struct import Vertex, Graph, MAX_COST
import math
import random


# produce n random shuffle a list
def random_shuffle(sol, n):
    sol_list = []
    for i in range(n):
        sol_new = sol[:]
        random.shuffle(sol_new)
        sol_list.append(sol_new)
    return sol_list


# produce n neighbor in a list
def get_neighbors(sol, n):
    neighbor = [sol, ]
    max_n = min(int(math.sqrt(n*2)) + 1, len(sol))
    swap_list = random.sample(range(0, len(sol)), max_n)

    for i in swap_list:
        for j in swap_list:
            if i < j:
                continue
            sol_m = sol[:]
            sol_m[i], sol_m[j] = sol_m[j], sol_m[i]
            neighbor.append(sol_m)

    return random.sample(neighbor, min(n, len(neighbor)))


# 2-approximation tour for given paritial graph
def approx2(graph):
    mst_edge = _mst(graph)
    d_mst_edge = list(mst_edge) + \
                 list(map(lambda x: (x[1], x[0]), list(mst_edge)))
    e_tour = _eulerian_tour(d_mst_edge)

    tour = []
    for v in e_tour:
        if v not in tour:
            tour.append(v)
    return tour


# MST solver by https://gist.github.com/siddMahen/8261350
def _mst(graph):
    T = set()
    X = set()
    X.add(0)

    vertex_num = graph.vertex_num()
    while len(X) != vertex_num:
        crossing = set()
        for x in X:
            for k in range(vertex_num):
                if k not in X:
                    crossing.add((x, k))
        edge = sorted(crossing, key=lambda e: graph.dist(e[0], e[1]))[0]
        T.add(edge)
        X.add(edge[1])

    return T


# Euclidean Tour by http://stackoverflow.com/questions/12447880/finding-a-eulerian-tour
def _eulerian_tour(graph):
    def _next_node(edge, current):
        return edge[0] if current == edge[1] else edge[1]

    def _remove_edge(raw_list, discard):
        return [item for item in raw_list if item != discard]

    search = [[[], graph[0][0], graph]]
    while search:
        path, node, unexplore = search.pop()
        path += [node]

        if not unexplore:
            return path

        for edge in unexplore:
            if node in edge:
                search += [[path, _next_node(edge, node), _remove_edge(unexplore, edge)]]
