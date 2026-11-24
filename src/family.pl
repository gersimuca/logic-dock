% LogicDock example knowledge base

% Facts

parent(john, mary).
parent(mary, alice).
parent(john, peter).

% Rules

grandparent(X, Y) :-
    parent(X, Z),
    parent(Z, Y).

grandchild(X, Y) :-
    grandparent(Y, X).
