from struct import Vertex, Graph, MAX_COST
from helper import random_shuffle, get_neighbors, approx2
from functools import reduce


# Get approx2 solution for batch size, and optimize each of them
def get_partial_tour(args, graph):
    if args.verbose: print('++ Use Batch Size: %s' % args.batch_size)

    vertex_list = graph.vertex_list()[:]
    tour_list = []; idx = 0
    while vertex_list:
        if args.verbose: print('++ %s Vertices Left' % len(vertex_list))
        split_vertex = vertex_list[:min(args.batch_size, len(vertex_list))]

        partial_graph = Graph(split_vertex)
        tour = approx2(partial_graph)
        opt_tour = _local_search(args, partial_graph, tour,
                                 args.iter_num1, args.neighbor_size1)[0]

        tour_list.append(list(map(lambda x:x+idx, opt_tour))); idx += args.batch_size
        vertex_list = vertex_list[args.batch_size:]
    return tour_list


# Merge splitted solution and optimize its order
def merge_tour(args, graph, tour_list):
    tour = _local_search(args, graph, tour_list,
                         args.iter_num2, args.neighbor_size2)[0]
    return reduce(lambda x, y: x+y, tour)


# Optimize the entire tour
def optimize_tour(args, graph, init_tour):
    return _local_search(args, graph, init_tour,
                         args.iter_num2, args.neighbor_size2)


# The main tabu search algorithm
def _local_search(args, graph, init_sol, iter_num, neighbor_size):
    if args.verbose: print('++ Starting Local Search')

    init_cost = graph.travel(init_sol)

    sol = init_sol
    sol_cost = graph.travel(sol)

    sol_best = sol
    sol_best_cost = graph.travel(sol_best)

    Q = []
    for i in range(iter_num):
        c_best, c_best_cost = None, MAX_COST
        neighbors = get_neighbors(sol, neighbor_size)
        for c in neighbors:
            if c not in Q:
                c_cost = graph.travel(c)
                if c_cost < c_best_cost:
                    c_best, c_best_cost = c, c_cost

        if c_best is not None:
            sol, sol_cost = c_best, c_best_cost

        if sol_cost < sol_best_cost:
            sol_best, sol_best_cost = sol, sol_cost

        Q.append(c_best)
        if len(Q) > args.queue_size:
            Q = Q[1:]

        if args.verbose: print('++ Iteration %s: Cost %s' % (i, sol_best_cost))

    if args.verbose:
        percent = (init_cost - sol_best_cost) / sol_best_cost * 100
        print('++ Reduced Cost: %s -> %s (%s%%)' % (init_cost, sol_best_cost, percent))
    return sol_best, sol_best_cost

