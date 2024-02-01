
% MI = Misioneros en la orilla izquierda
% CI= Canivales en la orilla izquierda
% CD= Canivales en la orilla derecha 
% MD= Misioneros en la orilla derecha 

% Salida del programa / Llama una lista de movimientos y la procesa recursivamente
salida([]) :- nl, nl.  %En este linea se define el caso base para la función salida. Si la lista de mov está vacía se imprimen espacios en blanco 
%Se define la función salida para imprimir los movimeintos realizados en el programa
salida([[MI,CI,String]|T]) :-  %Define el comportamiento de la funcion de salida. La lista se descompone en su primer elemento [[MI,CI,String] y el resto de la lista en [T]
   % MI en esta parte representa el estado despues del movimiento mientras que CI represnta antes del movimiento  y String la descripción
    salida(T), %Llamada recursiva a la función salida con el resto de la lista (T)- hará el resto de los movimientos e imprime cada uno de ellos
               %hasta que se alcance el caso base que es la lista vacía
    write(CI), write(' ~~ '), write(MI), write(': '), write(String), nl.
		% Imprime el movimiento actual despues de haber procesado el resto de la lista CI imprime el estado antes del mov y MI antes del mov
		%Mientras que String  imprime la descripcion del movimiento (se describen abajo) 

% Verificar que el movimiento es legal / O sea las restricciones del problema 
restriccion([MI,CI,_]) :- % lista con las variables de misioneros y canibales en la orilla izquierda
    (MI >= CI; MI = 0), % Se condiciona que el numero de misioneros debe ser mayor o igual que lo de los canibales en la orilla izquierda, o simplemente no haber 
    MD is 3 - MI, CD is 3 - CI, %MD y CD Calcula el numero de misioneros y canibales en la orilla derecha
    % Como sabemos que son 3 misioneros y 3 canibales por eso se calcula de diche forma (3-MI y 3-CI)
    (MD >= CD; MD = 0). % Lo mismo pero por la orilla derecha

% Caso base de la solucion
solucion([MI,CI,MD],[MI,CI,MD], Transicion, Movimiento) :- % Cuando el estado actual de MI, CI, MD es igual al estado objetivo
    salida(Movimiento). %Manda a llamar la funcion salida que es la que imprime la secuencia de mov realizados

% solucion recursiva
solucion([MI,CI,MD], [CD,E,F], Transicion, Movimiento) :- %Toma 4 argumentos del juego, [MI,CI, MD] que es el estado actual , [CD,E,F] refiriendose al objetivo, 
    													%la lista Transicion  mantiene los estados previos para evitar ciclos, y la lista Movimientos que registra
    													%los movimientos realizados hasta el momento. 
    move([MI,CI,MD], [I,J,K], Salida), %LLama la función move (se define en la parte inferior) Con estado actual [MI,CI,MD] y en espera de un nuevo estado [I,J,K]
    									%Asi mismo se llama la función salida para añadir un descripcion al movimiento
    restriccion([I,J,K]), % Manda a llamar la función de restriccion con el nuevo estado [I,J,K] para ver si cumple con las reglas (ver que no ponga a los misioneros en peligro]
    not(pertenece([I,J,K], Transicion)), % esta linea basicamente se asegura que el estado [I,J,K] no se haya alcanzado anteriormente (evitar ciclos y repeticiones)
    solucion([I,J,K], [CD,E,F], [[I,J,K]|Transicion], [[[I,J,K],[MI,CI,MD], Salida] | Movimiento]). %Realiza una llamada recursiva a solucion con el nuevo estado inicial [I,J,K],
																								    %el estado objetivo[CD, E,F], una lista de transición actualizada que incluye 
																									%el nuevo movimiento. Esto se repite hasta encontrar la solucion


% Verificar si un elemento pertenece a una lista
pertenece(X,[X|_]). %Se define la función pertenece (que se llama en la función solución)
pertenece(X,[_|Y]) :- pertenece(X, Y). %Verifica si un elemento X está presentr en una lista

% Se define la función move que describe todos los posibles movimientos en el juego
move([MI,CI, izq], [MD,CI, der], 'Un misionero cruzo el rio') :- MI > 0, MD is MI - 1.
%MI represneta el numero de misioneros en la orilla izquierda y MD despues del movimiento. La condición MI>0 asegura que al menos haya un misionero al cruzar
%y MD is MI-1 actualiza el número de misioneros en la orilla izquierda 
move([MI,CI, izq], [MD,CI, der], 'Dos misioneros cruzaron el rio') :- MI > 1, MD is MI - 2.
%Similar al caso anterior, pero aqui dos misioneros cruzan el rio. Se verifica al menos haya dos misioneres y se actualiza el numero de ellos restando 2 a MI
move([MI,CI, izq], [MD,CD, der], 'Un misionero y un canibal cruzaron el rio') :- MI > 0, CI > 0, MD is MI - 1, CD is CI - 1.
% Se compureba que al menos haya un misionero y un canival en el lado izquierdo  y se actualizan las cantidades de misioneros y canibales
move([MI,CI, izq], [MI,CD, der], 'Un canibal cruzo el rio') :- CI > 0, CD is CI - 1.
%Se requiere que al menos haya un canobal (CI>=0) y se actauliza el numero de canobales en el lado izquierdo
move([MI,CI, izq], [MI,CD, der], 'Dos canibales cruzaron el rio') :- CI > 1, CD is CI - 2.
%Necesitamos que al menos haya dos canibales por ello el CI>1, y se actualiza el numero de canibales en el lado izquierdo
move([MI,CI, der], [MD,CI, izq], 'Un misionero regreso del otro lado') :- MI < 3, MD is MI + 1.
%Define el movimiento para cuando un misionero regrese del otro lado. Se asegura que haya espacio y se aumenta el numero en la orilla izquierda
move([MI,CI, der], [MD,CI, izq], 'Dos misioneros regresaron del otro lado') :- MI < 2, MD is MI + 2.
%Similar a lo anterior, primero se verifica que hay espacio para dos misioneros más y se le amumentan 2 a la orilla izquierda
move([MI,CI, der], [MD,CD, izq], 'Un misionero y un canibal regresaron del otro lado') :- MI < 3, CI < 3, MD is MI + 1, CD is CI + 1.
%Primero se tiene que asegurar que haya espacio para ambos, y se le aumenta en 1 a los misioneros y a los canibales de la izquierda
move([MI,CI, der], [MI,CD, izq], 'Un canibal regreso del otro lado') :- CI < 3, CD is CI + 1.
%Un canibal regrese , necesita que haya espacio para uno más y posteriormente se le suma 1 al numero de canibales
move([MI,CI, der], [MI,CD, izq], 'Dos canibales regresaron del otro lado') :- CI < 2, CD is CI + 2.
%El ultimo movimiento posible es que dos canibales se regresen, primero se confirma que haya espacio para ellos y posteriormente se le suman los 2 al lado izquierdo

