-module(util).
-export([list_to_float/1]).

list_to_float(S) ->
	case string:str(S, ".") of
		0 ->
			list_to_integer(S) * 1.0;
		_ ->
			erlang:list_to_float(S)
	end.
