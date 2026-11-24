parent(john, mary).
parent(mary, alice).
parent(john, peter).

grandparent(X, Y) :-
    parent(X, Z),
    parent(Z, Y).

grandchild(X, Y) :-
    grandparent(Y, X).
