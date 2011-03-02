set ERL_LIBS=../lib:%ERL_LIBS%

erl -sname eb_node -eval 'application:start(erlybank).'


