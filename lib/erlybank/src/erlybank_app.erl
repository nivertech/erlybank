-module(erlybank_app).
-beahviour(application).
-export([start/2,stop/1]).
start(_Type, _Args) ->
	eb_server_sup:start_link().
stop(_State) ->
	ok.
