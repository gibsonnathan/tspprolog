travel(List, Result) :-
    permute(List, P),
    [Head | Tail] = P,
    travelhelper(Tail, Head),
    Result = Head.
    
travelhelper([], _).
    
travelhelper([Head | Tail], Current) :-
    smaller(Head, Current, X),
    write(X),
    nl(),
    travelhelper(Tail, X).


smaller(X, Y, Y) :-
    totaldistancetraveled(X, ResX),
    totaldistancetraveled(Y, ResY),
    ResY < ResX.
    
smaller(X, Y, X) :-
    totaldistancetraveled(X, ResX),
    totaldistancetraveled(Y, ResY),
    ResY >= ResX.
  
totaldistancetraveled([[City1, [X1, Y1]]], Result) :-
    Result is 0.

totaldistancetraveled([[City1, [X1, Y1]] | Rest], Result) :-
    [[City2, [X2, Y2]] | More] = Rest,
    distancebetween(X1, Y1, X2, Y2, PartialResult),
    totaldistancetraveled(Rest, RemainingResult),
    Result is PartialResult + RemainingResult.


printcities([[X | Y] | Rest]) :-
    write(X),
    nl(),
    printcities(Rest).

distancebetween(X1, Y1, X2, Y2, Distance) :-
    X is X2 - X1,
    Y is Y2 - Y1,
    square(X, XSq),
    square(Y, YSq),
    Sum is XSq + YSq,
    sqrt(Sum, Distance).

square(X, Result) :-
    Result is X * X.

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
    append(FirstPermutes, RestPermutes, Permutations).

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