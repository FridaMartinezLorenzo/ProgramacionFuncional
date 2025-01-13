-module(intro).

-export([start/0,fact/1,ciclo/0]).

start() ->
	register(holl,spawn(intro,ciclo,[])),
	io:format("hola mundo~n",[]).

fact(0) -> 1;
fact(N) when N>0  -> N*fact(N-1).

ciclo() ->
	receive
	   casa -> io:format("hola casa~n~p",[fact(10)]),
	   register(coche,spawn(intro,ciclo,[])),
	   ciclo();
	   jardin -> io:format("hola jardin~n",[]),
	   ciclo();
	   garage -> io:format("hola gar gar~n",[]),
	   ciclo()
	   end.