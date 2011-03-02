-module(eb).

-export([start/0, stop/0, create_account/1, delete_account/1, deposit/2, withdraw/2, balance/1]).

start() -> 
	application:start(erlybank).
stop() -> 
	application:stop(erlybank).
create_account(X) -> 
	eb_server:create_account(X).
delete_account(X) ->
	eb_server:delete_account(X).
deposit(X,Y) -> 
	eb_server:deposit(X,Y).
withdraw(X,Y) ->
	eb_server:withdraw(X,Y).
balance(X) ->
	eb_server:balance(X).



