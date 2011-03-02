set ERL_LIBS=../lib:%ERL_LIBS%

erl -sname eb_node -boot start_sasl -eval 'application:start(erlybank).'


