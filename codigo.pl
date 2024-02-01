
% MI = Misioneros en la orilla izquierda
% CI= Canivales en la orilla izquierda
% CD= Canivales en la orilla derecha 
% MD= Misioneros en la orilla derecha 

% Salida del programa
salida([]) :- nl, nl.
salida([[MI,CI,String]|T]) :-
    salida(T),
    write(CI), write(' ~~ '), write(MI), write(': '), write(String), nl.


% Verificar que el movimiento es legal
restriccion([MI,CI,_]) :-
    (MI >= CI; MI = 0), % No más caníbales que misioneros en la orilla izquierda, a menos que no haya misioneros
    MD is 3 - MI, CD is 3 - CI,
    (MD >= CD; MD = 0). % Lo mismo para la orilla derecha

% Caso base de la búsqueda
solucion([MI,CI,MD],[MI,CI,MD], Transicion, Movimiento) :-
    salida(Movimiento).

% Búsqueda recursiva
solucion([MI,CI,MD], [CD,E,F], Transicion, Movimiento) :-
    move([MI,CI,MD], [I,J,K], Salida),
    restriccion([I,J,K]), % Solo usar este movimiento si es seguro
    not(pertenece([I,J,K], Transicion)),
    solucion([I,J,K], [CD,E,F], [[I,J,K]|Transicion], [[[I,J,K],[MI,CI,MD], Salida] | Movimiento]).


% Verificar si un elemento pertenece a una lista
pertenece(X,[X|_]).
pertenece(X,[_|Y]) :- pertenece(X, Y).

% Se define la función move que describe todos los posibles movimientos en el juego
move([MI,CI, izq], [MD,CI, der], 'Un misionero cruzo el rio') :- MI > 0, MD is MI - 1.
move([MI,CI, izq], [MD,CI, der], 'Dos misioneros cruzaron el rio') :- MI > 1, MD is MI - 2.
move([MI,CI, izq], [MD,CD, der], 'Un misionero y un canibal cruzaron el rio') :- MI > 0, CI > 0, MD is MI - 1, CD is CI - 1.
move([MI,CI, izq], [MI,CD, der], 'Un canibal cruzo el rio') :- CI > 0, CD is CI - 1.
move([MI,CI, izq], [MI,CD, der], 'Dos canibales cruzaron el rio') :- CI > 1, CD is CI - 2.
move([MI,CI, der], [MD,CI, izq], 'Un misionero regreso del otro lado') :- MI < 3, MD is MI + 1.
move([MI,CI, der], [MD,CI, izq], 'Dos misioneros regresaron del otro lado') :- MI < 2, MD is MI + 2.
move([MI,CI, der], [MD,CD, izq], 'Un misionero y un canibal regresaron del otro lado') :- MI < 3, CI < 3, MD is MI + 1, CD is CI + 1.
move([MI,CI, der], [MI,CD, izq], 'Un canibal regreso del otro lado') :- CI < 3, CD is CI + 1.
move([MI,CI, der], [MI,CD, izq], 'Dos canibales regresaron del otro lado') :- CI < 2, CD is CI + 2.



