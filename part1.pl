solve(M, N, Bomb1, Bomb2) :-
    initialState(M, N, Bomb1, Bomb2, State),
    search([[State, null]], [],[M,N]).

initialState(M, N, Bomb1, Bomb2, InitState) :-
    generate_board(M, N, EmptyBoard),
    nth0(0, Bomb1, Row1),
    nth0(1, Bomb1, Col1),
    Bomb1Index is Row1 * N + Col1,
    replace(Bomb1Index, EmptyBoard, 'b', BoardWithBomb1),
    nth0(0, Bomb2, Row2),
    nth0(1, Bomb2, Col2),
    Bomb2Index is Row2 * N + Col2,
    replace(Bomb2Index, BoardWithBomb1, 'b', InitState).

generate_board(M,N, Board) :-
    L is M * N,
    length(Board, L),
    maplist(=(#), Board).

search(Open, Closed,[_,_]):-
getState(Open, [CurrentState,Parent], _), % Step 1
% write("Search is complete!"), nl,
printSolution([CurrentState,Parent], Closed).

search(Open, Closed,[M,N]):-
getState(Open, CurrentNode, TmpOpen),
getValidChildren(CurrentNode,TmpOpen,Closed,Children,[M,N]), % Step3
addChildren(Children, TmpOpen, NewOpen), % Step 4
append(Closed, [CurrentNode], NewClosed), % Step 5.1
search(NewOpen, NewClosed,[M,N]). % Step 5.2

% Implementation of step 3 to get the next states
getValidChildren(Node, Open, Closed, Children,[M,N]):-
findall(Next, getNextState(Node, Open, Closed, Next,[M,N]), Children).

getNextState([State,_], Open, Closed, [Next,State],[M,N]):-
move(State, Next,[M,N]),
not(member([Next,_], Open)),
not(member([Next,_], Closed)),
isOkay(Next).

getState([CurrentNode|Rest], CurrentNode, Rest).

addChildren(Children, Open, NewOpen):-
append(Open, Children, NewOpen).

% Implementation of printSolution to print the actual solution path
printSolution([State, null],_):-
write(State), nl.

printSolution([State, Parent], Closed):-
member([Parent, GrandParent], Closed),
printSolution([Parent, GrandParent], Closed),
write(State), nl.
% How can we implement DFS, DLS and UCS?

move(State, Next,[M,N]):-
horiz(State, Next,[M,N]);vert(State, Next,[M,N]).

horizontal(State, Next,[M,N]):-
nth0(EmptyTileIndex, State, #),
EmptyTileIndex \= M*N-1,
NewIndex is EmptyTileIndex + 1,
nth0(NewIndex, State, Element),
Element = #,
replace(EmptyTileIndex, State,'_', Result),
replace(NewIndex, Result,'_', Next).

vertical(State, Next,[M,N]):-
nth0(EmptyTileIndex, State, #),
% check if we on last row
L is M*N,
RowIndex is EmptyTileIndex // N,
LastRowIndex is L // N - 1,
not(RowIndex =:= LastRowIndex),
NewIndex is EmptyTileIndex + N,
nth0(NewIndex, State, Element),
Element = #,
replace(EmptyTileIndex, State,'|', Result),
replace(NewIndex, Result,'|', Next).


replace(I, L, E, K) :-
  nth0(I, L, _, R),
  nth0(I, K, E, R).

isOkay(_):- true. % This problem has no rules
