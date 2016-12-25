from struct import Vertex, Graph, MAX_COST
from parser import parse
from engine import get_partial_tour, merge_tour, optimize_tour
import argparse


def main():
    parser = argparse.ArgumentParser(description='Get approx solution of give TSP')
    parser.add_argument('file_name', help='graph data file')
    parser.add_argument('-v', action='store_true', dest='verbose')
    parser.add_argument('--batch-size', dest='batch_size', type=int, default=200,
                        help='size of partial graph')
    parser.add_argument('--iter-num1', dest='iter_num1', type=int, default=200,
                        help='iteration number of phase1')
    parser.add_argument('--iter-num2', dest='iter_num2', type=int, default=100,
                        help='iteration number of phase2 and 3')
    parser.add_argument('--queue-size', dest='queue_size', type=int, default=1000,
                        help='queue size')
    parser.add_argument('--neighbor-size1', dest='neighbor_size1', type=int, default=300,
                        help='neighbor size of phase1')
    parser.add_argument('--neighbor-size2', dest='neighbor_size2', type=int, default=100,
                        help='neighbor size of phase2 and 3')
    args = parser.parse_args()
    graph = parse(args.file_name)

    if not graph:
        print('- invalid graph file')
        exit(1)

    if args.verbose: print('+ Phase1: Calculating Partial Optimized Tour')
    tour_list = get_partial_tour(args, graph)

    if args.verbose: print('+ Phase2: Merging 2-approx Tour')
    init_tour = merge_tour(args, graph, tour_list)

    if args.verbose: print('+ Phase3: Optimizing Solution using Local Search')
    tour, cost = optimize_tour(args, graph, init_tour)

    if args.verbose: print('+ Verifying Solution')
    for i in range(graph.vertex_num()):
        if i not in tour:
            print('- Verify Failed: Vertex %s not in Tour' % i)

    with open('solution.csv', 'w') as f:
        for item in tour:
            f.write("%s\n" % (item+1))

    print('+ Done! Cost: %s, Optimal Tour was saved to solution.csv' % cost)


if __name__ == '__main__':
    main()

