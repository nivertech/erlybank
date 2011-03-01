-module(eb).

-export([start/0, stop/0, create_account/1, deposit/2]).

start() -> 
	application:start(erlybank).
stop() -> 
	application:stop(erlybank).
create_account(X) -> 
	eb_server:create_account(X).
deposit(X,Y) -> 
	eb_server:deposit(X,Y).



