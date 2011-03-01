ERL_LIBS=../lib:$ERL_LIBS
export ERL_LIBS

erl -sname kuku -eval 'application:start(erlybank), io:format("Loaded...").'


