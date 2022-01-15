-define(SystemTime,millisecond).

-define(Log_info(Msg,Args),
	{erlang:system_time(?SystemTime),node(),"INFO  ",Msg,?MODULE,?FUNCTION_NAME,?LINE,Args,new}).
-define(Log_ticket(Msg,Args),
	{erlang:system_time(?SystemTime),node(),"TICKET",Msg,?MODULE,?FUNCTION_NAME,?LINE,Args,new}).
-define(Log_alert(Msg,Args),
	{erlang:system_time(?SystemTime),node(),"ALERT ",Msg,?MODULE,?FUNCTION_NAME,?LINE,Args,new}).
