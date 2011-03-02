set ERL_LIBS=../lib:%ERL_LIBS%

erl -sname eb_web -boot start_sasl -eval '[application:start(A)||A<-[crypto,inets,mochieb]]'


