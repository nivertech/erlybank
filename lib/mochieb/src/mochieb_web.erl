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

http_status(ok) ->
    204;
http_status({ok,_}) ->
    204;
http_status(_) ->
    500.

req_handle('GET', ["balance", Name], Req) ->
    case eb:balance(Name) of
        {ok,X} ->
            Req:respond({200, [], 
                         list_to_binary(util:float_to_list(X))});
        _ ->
            Req:respond({500, [], []})
    end;
req_handle('GET', ["ui", Name], Req) ->
	QS = Req:parse_qs(),
	Redirect = 
		case {lists:keysearch("command", 1, QS),
			  lists:keysearch("amount",  1, QS)} of 
			{{value, {"command", "Deposit"}}, {value, {"amount", Amount}}} ->
				eb:deposit(Name, util:list_to_float(Amount)),
				true;
			{{value, {"command", "Withdraw"}}, {value, {"amount", Amount}}} ->
				eb:withdraw(Name, util:list_to_float(Amount)),
				true;
			_ ->
				false
		end,
	case Redirect of 
		true ->
			Loc = ("http://" ++ 
				   mochiweb_headers:get_value("host", Req:get(headers)) ++ 
				   "/ui/" ++ Name),
			Req:respond({302, [{"Location", Loc},
							   {"Content-Type", "text/html; charset=UTF-8"}], 
						 ""});
		false ->
			case eb:balance(Name) of
				{ok, Balance} ->
					case account_dtl:render([{name, Name}, 
											 {current_amount, Balance}]) of
						{ok, HTML} ->
							Req:ok({ "text/html; charset=utf-8", % mime-type
									 [],                         % headers
									 HTML } );
						_ ->
							Req:respond({500, [], []})
					end;
				_ ->
					Req:respond({500, [], "User does not exist"})
			end
	end;

req_handle('GET', _, Req) ->
    Req:not_found();
req_handle('PUT', ["account", Name], Req) ->
    Status = http_status(eb:create_account(Name)),
    Req:respond({Status, [], []});
req_handle('PUT', _, Req) ->
    Req:not_found();
req_handle('POST', ["deposit", Name, Amount], Req) ->
    Status = http_status(eb:deposit(Name, util:list_to_float(Amount))),
    Req:respond({Status, [], []});
req_handle('POST', ["withdraw", Name, Amount], Req) ->
    Status = http_status(eb:withdraw(Name, util:list_to_float(Amount))),
    Req:respond({Status, [], []});
req_handle('POST', _, Req) ->
    Req:not_found();
req_handle('DELETE', ["account", Name], Req) ->
    Status = http_status(eb:delete_account(Name)),
    Req:respond({Status, [], []});
req_handle('DELETE', _, Req) ->
    Req:not_found();
req_handle(_,_,Req) ->
    Req:respond({501, [], []}).


loop(Req, DocRoot) ->
    "/" ++ Path = Req:get(path),
    Tokens = string:tokens(Path, "/"),
    req_handle(Req:get(method), Tokens, Req).

%% Internal API

get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.


%%
%% Tests
%%
-include_lib("eunit/include/eunit.hrl").
-ifdef(TEST).
-endif.
