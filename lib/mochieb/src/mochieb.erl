%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc TEMPLATE.

-module(mochieb).
-author('author <author@example.com>').
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

%% @spec start() -> ok
%% @doc Start the mochieb server.
start() ->
    mochieb_deps:ensure(),
    ensure_started(crypto),
    application:start(mochieb).

%% @spec stop() -> ok
%% @doc Stop the mochieb server.
stop() ->
    Res = application:stop(mochieb),
    application:stop(crypto),
    Res.
