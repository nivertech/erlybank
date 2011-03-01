%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Web server for mochieb.

-module(mochieb_web).
-author('author <author@example.com>').

-export([start/1, stop/0, loop/2]).

%% External API

start(Options) ->
    {DocRoot, Options1} = get_option(docroot, Options),
    Loop = fun (Req) ->
                   ?MODULE:loop(Req, DocRoot)
           end,
    mochiweb_http:start([{name, ?MODULE}, {loop, Loop} | Options1]).

stop() ->
    mochiweb_http:stop(?MODULE).

loop(Req, DocRoot) ->
    "/" ++ Path = Req:get(path),
	Tokens = string:tokens(Path, "/"),
    case Req:get(method) of
        Method when Method =:= 'GET'; Method =:= 'HEAD' ->
            case Tokens of
				["balance", Name] ->
					case eb:balance(Name) of
						{ok,X} ->
							Req:respond({200, [], 
										 list_to_binary(integer_to_list(X))});
						_ ->
							Req:respond({500, [], []})
					end;
                _ ->
                    Req:not_found()
            end;
        'POST' ->
			case Tokens of
				["create_account", Name] ->
					case eb:create_account(Name) of
						ok -> Req:respond({204, [], []});
						_  -> Req:respond({500, [], []})
					end;
				["deposit", Name, Amount] ->
					case eb:deposit(Name, list_to_integer(Amount)) of
						{ok,_} -> Req:respond({204, [], []});
						_      -> Req:respond({500, [], []})
					end;
				["withdraw", Name, Amount] ->
					case eb:withdraw(Name, list_to_integer(Amount)) of
						{ok,_} -> Req:respond({204, [], []});
						_      -> Req:respond({500, [], []})
					end;
				["delete_account", Name] ->
					case eb:delete_account(Name) of
						ok -> Req:respond({204, [], []});
						_  -> Req:respond({500, [], []})
					end;
				_ ->
                    Req:not_found()
            end;
        _ ->
            Req:respond({501, [], []})
    end.

%% Internal API

get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.


%%
%% Tests
%%
-include_lib("eunit/include/eunit.hrl").
-ifdef(TEST).
-endif.
