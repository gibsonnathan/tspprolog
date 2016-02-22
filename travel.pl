% Nathan Gibson
% February 21, 2015
%
% Program solves the traveling salesman problem by taking a list of cities
% and coordinates, permuting all possible orderings of the list and then
% choosing the ordering that requires the least distance to be traveled. 
%
% example usage: travel([ [ atlanta, [50, 50] ], [ orlando, [100, -225] ], [ knoxville, [60, 100] ], [ dothan, [500, 500] ] ], X).
% example usage: printcities([[dothan, [500, 500]], [knoxville, [60, 100]], [atlanta, [50, 50]], [orlando, [100, -225]]]).

% Predicate that takes a list, permutes all possibilities of the list
% and passes those permutations to the travel helper to find the shortest path
%
travel(List, Result) :-
    permute(List, P),
    [Head | Tail] = P,
    travelhelper(Tail, Head, X),
    Result = X.
    
% base case for travel helper that states that the Answer to 
% an empty list of trips is the last value of Current.
%
travelhelper([], X, X).
    
% Predicate that takes a list of trips and determines
% which trip cost the least distance
%
travelhelper([Head | Tail], Current, Answer) :-
    smaller(Head, Current, X),
    travelhelper(Tail, X, Y),
    Answer = Y.
    
% Predicate that checks to see if trip Y was less
% distance than trip X
%
smaller(X, Y, Y) :-
    totaldistancetraveled(X, ResX),
    totaldistancetraveled(Y, ResY),
    ResY < ResX.

% Predicate that checks to see if trip X was less
% distance than trip Y
%
smaller(X, Y, X) :-
    totaldistancetraveled(X, ResX),
    totaldistancetraveled(Y, ResY),
    ResY >= ResX.
  
% base case for totaldistancetraveled that states
% the total distance traveled from one location to that
% same location is 0
%
totaldistancetraveled([[_, [_, _]]], Result) :-
    Result is 0.

% calculates the distance traveled in one trip
%
totaldistancetraveled([[_, [X1, Y1]] | Rest], Result) :-
    [[_, [X2, Y2]] | _] = Rest,
    distancebetween(X1, Y1, X2, Y2, PartialResult),
    totaldistancetraveled(Rest, RemainingResult),
    Result is PartialResult + RemainingResult.

% base case for printcities stating that the empty list should
% return true
%
printcities([]).

% takes the detailed list and prints out the city names followed by newlines
%
printcities([[X | _] | Rest]) :-
    write(X),
    nl(),
    printcities(Rest).

% returns the distance between two points
%
distancebetween(X1, Y1, X2, Y2, Distance) :-
    X is X2 - X1,
    Y is Y2 - Y1,
    square(X, XSq),
    square(Y, YSq),
    Sum is XSq + YSq,
    sqrt(Sum, Distance).

% Auxiliary predicate to determine the square of a number
%
square(X, Result) :-
    Result is X * X.

% All permutation code including "permute", "for_each",
% "remove_first", and "add_to_each" are from with the exception of a reimplementation of
% "append" called "myappend":
% http://cscnew.columbusstate.edu/eckart/classes/cpsc5135/topics/topic_13.shtml
% Permute yields a list of lists ("Permutations").
%
permute([], []).
permute([X], [[X]]).
permute(List, Permutations) :-
    for_each(List, List, Permutations).

% Uses each element of "Member" as basis for a reduced permute
% problem on the other elements of "List". Returns a list of lists
% ("Permutations").
%
for_each([], _, []).
for_each([FirstMember | RestMembers], List, Permutations) :-
    remove_first(FirstMember, List, SmallerList),
    permute(SmallerList, SmallerListPermutes),
    add_to_each(FirstMember, SmallerListPermutes, FirstPermutes),
    for_each(RestMembers, List, RestPermutes),
    myappend(FirstPermutes, RestPermutes, Permutations).

% Removes only the first occurrence of "Item" from the "List".
% Note the use of cut (!) to prevent backtracking.
%
remove_first(_, [], []).
remove_first(Item, [Item | RestList], RestList) :- !.
remove_first(Item, [ListItem | RestList], [ListItem | NewList]) :-
    remove_first(Item, RestList, NewList), !.

% Adds the "Item" onto each sublist in the "List".
%
add_to_each(_, [], []).
add_to_each(Item, [List | RestLists], [[Item | List] | NewRestLists]) :-
    add_to_each(Item, RestLists, NewRestLists).
   
% base case states that a list appended to the empty list is that list
myappend([],X,X).                           

% auxiliary append function takes the first element of a list
% and recursively adds it on to a resulting list
myappend([X|Y],Z,[X|W]) :- 
    myappend(Y,Z,W).