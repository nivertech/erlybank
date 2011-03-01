-module(eb_sup).
-behaviour(supervisor).

-export([start_link/0,
		 init/1]).

start_link() ->
	supervisor:start_link(eb_sup, []).

init(_Args) ->
	{ok, {{one_for_one,100,60},
		  [{eb_server, {eb_server, start_link, []},
			permanent, brutal_kill, worker, [eb_server]}]}}.

