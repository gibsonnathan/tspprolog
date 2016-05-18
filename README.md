# tspprolog

Program solves the traveling salesman problem by taking a list of cities
and coordinates, permuting all possible orderings of the list and then
choosing the ordering that requires the least distance to be traveled. 

example usage: travel([ [ atlanta, [50, 50] ], [ orlando, [100, -225] ], [ knoxville, [60, 100] ], [ dothan, [500, 500] ] ], X).
example usage: printcities([[dothan, [500, 500]], [knoxville, [60, 100]], [atlanta, [50, 50]], [orlando, [100, -225]]]).

Predicate that takes a list, permutes all possibilities of the list
and passes those permutations to the travel helper to find the shortest path
