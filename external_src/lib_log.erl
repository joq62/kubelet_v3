%% Author: joqerlang
%% Created: 2021-11-18 
%% Connect/keep connections to other nodes
%% clean up of computer (removes all applications but keeps log file
%% git loads or remove an application ,loadand start application
%%  
%% Starts either as controller or worker node, given in application env 
%% Controller:
%%   git clone and starts 
%% 
%% Description: TODO: Add description to application_org
%% 
-module(lib_log).
 
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("log.hrl").
%% --------------------------------------------------------------------
%% Behavioural exports
%% --------------------------------------------------------------------
-export([
	 nice_print/1,
	 nice_print/2,
	 store/1,
	 print_all/0,
	 print_all/1,
	 read_all_info/0,
	 read_all_info/1
        ]).

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Macros
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Records
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% API Functions
%% --------------------------------------------------------------------

%% ====================================================================!
%% External functions
%% ====================================================================!
%% --------------------------------------------------------------------
%% Func: start/2
%% Returns: {ok, Pid}        |
%%          {ok, Pid, State} |
%%          {error, Reason}
%%---------------------------------------------------------------------

read_all_info()->
    Info=mnesia:dirty_all_keys(logger_info),
    SortedIdList=lists:reverse(lists:sort(Info)),
    SortedIdList.

 %   [db_log:read(Id)||Id<-SortedList].
  %  [{Id,db_log:read(Id)}||Id<-SortedList].

read_all_info(NumLatesId)->
    Info=mnesia:dirty_all_keys(logger_info),
    SortedIdList=lists:reverse([Id||Id<-lists:sort(Info),
				    Id>NumLatesId]),
    SortedIdList.		       
%    [db_log:read(Id)||Id<-lists:sublist(SortedList,NumLatesInfo)].
 %   [{Id,db_log:read(Id)}||Id<-lists:sublist(SortedList,NumLatesInfo)].

%% --------------------------------------------------------------------
%% Func: start/2
%% Returns: {ok, Pid}        |
%%          {ok, Pid, State} |
%%          {error, Reason}
%%---------------------------------------------------------------------
nice_print(Id)->
    nice_print(Id,node()).

nice_print(Id,Node)->
    case rpc:call(Node,db_log,read,[Id],5*1000) of
	{badrpc,Reason}->
	    {error,[badrpc,Reason]};
	{aborted,Reason}->
	    {error,Reason};
	Info->
	    nice_print_info(Info)
    end.

nice_print_info(Info)->
    {_Id,SystemTime,Node,Severity,Msg,Module,Function,Line,Args,_Status}=Info,
    Time=calendar:system_time_to_rfc3339(SystemTime,                
					 [{unit, ?SystemTime}, {time_designator, $\s}, {offset, "Z"}]),
    
    Node1=atom_to_list(Node),
    Severity1=" "++Severity,
    Module1=atom_to_list(Module),
    Function1=atom_to_list(Function),
    Line1=integer_to_list(Line),
						%Status1=atom_to_list(Status),
    Msg1=" "++Msg,
    MF=" "++Module1++":"++Function1,
    
	  %  io:format("MF ~p~n",[{Id,?MODULE,?FUNCTION_NAME,?LINE}]),	    
    io:format("~s ~s ~s >>> ~s ",[Time,Severity1,Msg1, MF]),
    io:format("Line=~s Node=~s ",[Line1,Node1]), 
   io:format(" ["),
    print(Args),
    io:format("] "),
 
    io:format("~n").

print([])->
    ok;
print([Arg|T]) ->
    io:format("~p",[Arg]),
    case T of
	[]->
	    ok;
	_ ->
	    io:format(",")
    end,
    print(T).
%% --------------------------------------------------------------------
%% Func: start/2
%% Returns: {ok, Pid}        |
%%          {ok, Pid, State} |
%%          {error, Reason}
%%---------------------------------------------------------------------
store(Info)->
    ok=rpc:call(node(),db_log,create,[Info],5*1000),
    ok.

print_all()->
    N=node(),
    Info=rpc:call(N,mnesia,dirty_all_keys,[logger_info],5*1000),
    SortedList=lists:reverse(lists:sort(Info)),
    [rpc:call(N,lib_log,nice_print,[Id],3*1000)||Id<-SortedList],
    ok.
print_all(NumLatesInfo)->
    N=node(),
    Info=rpc:call(N,mnesia,dirty_all_keys,[logger_info],5*1000),
    SortedList=lists:reverse(lists:sort(Info)),
    [rpc:call(N,lib_log,nice_print,[Id],3*1000)||Id<-lists:sublist(SortedList,NumLatesInfo)],
    ok.
