:- dynamic casilla/3.
:- dynamic turno/1.

%REGLAS

% Fase 1: donde cada jugador tiene que colocar las 3 fichas que tiene disponible

% Método para colocar la ficha en la casilla seleccionada por el jugador

% Validación del movimiento colocar para comprobar que la casilla no está ocupada
% previamente por ninguna otra ficha o no están todas las fichas ya puestas

comprobacion_mov_colocar(X, Y):-
	turno(T),
	\+ todas_puestas(T),
	\+ casilla(X, Y, _F).


movimiento_colocar(X, Y):-
	comprobacion_mov_colocar(X, Y),
	turno(T),
	assert(casilla(X, Y, T)),
	cambiar_turno.



%  Método que permite cambiar el turno del jugador

cambiar_turno:-
	turno(T1),
	contrario(T1,T2),
	retractall(turno(T1)),
	assert(turno(T2)).

% Fase 2: todas las fichas están dispuestas en el tablero por lo que se
% empieza a realizar el desplazamiento de fichas


% Método de validación del desplazamiento comprobando que la casilla no está
% ocupada y todas las fichas están puestas en el tablero

comprobacion_mov_desplazar(X1,Y1,X2,Y2):-
	turno(T),
	todas_puestas(T),
	casilla(X1, Y1, T),
	\+ casilla(X2, Y2, _F).


movimiento_desplazar(X1, Y1, X2, Y2):-
	comprobacion_mov_desplazar(X1, Y1, X2, Y2),
	turno(T),
	retractall(casilla(X1, Y1, T)),
	assert(casilla(X2, Y2, T)),
	(tres_en_raya;
	cambiar_turno).




% Método que nos permite saber si todas las fichas han sido colocadas en el tablero

todas_puestas(T):-
	findall((X, Y), casilla(X, Y, T),L),
	length(L, 3).


% Método que comprueba si el movimiento hecho cuando están todas las fichas puestas
% puede ser el movimiento ganador


tres_en_raya:-

	((casilla(1, 1, T), casilla(1,2,T), casilla(1,3,T));
	(casilla(2,1,T),casilla(2,2,T),casilla(2,3,T));
	(casilla(3,1,T),casilla(3,2,T),casilla(3,3,T));
	(casilla(1,1,T),casilla(2,1,T),casilla(3,1,T));
	(casilla(1,2,T),casilla(2,2,T),casilla(3,2,T));
	(casilla(1,3,T),casilla(2,3,T),casilla(3,3,T));
	(casilla(1,1,T),casilla(2,2,T),casilla(3,3,T));
	(casilla(1,3,T),casilla(2,2,T),casilla(3,1,T))),
	write("3 en raya, Ganador Jugador: "),
	write(T).

% Método para vaciar el tablero cuando se ha terminado la partida o
% cuando se quiera empezar una nueva.

tablero_vacio:-
	retractall(casilla(_X, _Y, _T)).





%HECHOS

tablero_vacio.
contrario(x, o).
contrario(o, x).
turno(o).


