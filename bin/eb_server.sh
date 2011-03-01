ERL_LIBS=../lib:$ERL_LIBS
export ERL_LIBS

erl -sname node_eb -boot start_sasl -eval 'application:start(erlybank), io:format("Loaded...").'


