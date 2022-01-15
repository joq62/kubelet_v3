
-module(db_log).
-import(lists, [foreach/2]).
%-compile(export_all).
-export([
	 update_status/2,
	 ids/0
	 
	]).


-export([
%	 data_from_file/1,
	 create_table/0,
	 delete_table_copy/1,
	 create/1,
	 add_table/1,
	 add_table/2,
	 add_node/3,
	 read_all_record/0,
	 read_all/0,
	 read_record/1,
	 read/1,
	 delete/1	 
	]).

-include_lib("stdlib/include/qlc.hrl").

-define(TABLE,logger_info).
-define(RECORD,logger_info). 


-record(logger_info,
	{
	 id,        % erlang:system_time(microsecond)
	 time,      % time()
	 node,      % node()
	 severity,  % alert, ticket, info
	 msg,       % free text
	 module,    % ?MODULE
	 function,  % ?FUNCTION_NAME
	 line,      % ?LINE
	 args,      % [erlang terms]
	 status     % new, read, cleared
	}).

%%------------------------- Application specific commands ----------------
ids()->
    [Id||{Id,_Date,_Time,_Node,_Severity,_Msg,_Module,_Function,_Line,_Args,_Status}<-read_all()].
    

%%------------------------- Generic  dbase commands ----------------------
create_table()->
  Result=case mnesia:create_table(?TABLE, [{attributes, record_info(fields, ?RECORD)}]) of
	     {atomic,ok}->
		 mnesia:wait_for_tables([?TABLE], 20000);
	     {aborted,Reason}->
		 {aborted,Reason}
	 end, 
    Result. 
delete_table_copy(Dest)->
    mnesia:del_table_copy(?TABLE,Dest).

create({Time,Node,Severity,Msg,Module,Function,Line,Args,Status}) ->
    Id=erlang:system_time(microsecond),
%    io:format(" ~p~n",[{Date,Time,Node,Severity,Msg,Module,Function,Line,Args,Status}]),
    F = fun() ->
		Record=#?RECORD{
				id=Id,        
				time=Time, 
				node=Node,      
				severity=Severity,  
				msg=Msg,      
				module=Module,   
				function=Function,  
				line=Line,      
				args=Args,      
				status=Status    
			       },		
		mnesia:write(Record) end,
    case mnesia:transaction(F) of
	{atomic,ok}->
	    ok;
	ErrorReason ->
	    ErrorReason
    end.

add_table(Node,StorageType)->
    mnesia:add_table_copy(?TABLE, Node, StorageType).


add_table(StorageType)->
    mnesia:add_table_copy(?TABLE, node(), StorageType),
    Tables=mnesia:system_info(tables),
    mnesia:wait_for_tables(Tables,20*1000).

add_node(Dest,Source,StorageType)->
    mnesia:del_table_copy(schema,Dest),
    mnesia:del_table_copy(?TABLE,Dest),
    io:format("Node~p~n",[{Dest,Source,?FUNCTION_NAME,?MODULE,?LINE}]),
    Result=case mnesia:change_config(extra_db_nodes, [Dest]) of
	       {ok,[Dest]}->
		 %  io:format("add_table_copy(schema) ~p~n",[{Dest,Source, mnesia:add_table_copy(schema,Source,StorageType),?FUNCTION_NAME,?MODULE,?LINE}]),
		   mnesia:add_table_copy(schema,Source,StorageType),
		%   io:format("add_table_copy(table) ~p~n",[{Dest,Source, mnesia:add_table_copy(?TABLE,Dest,StorageType),?FUNCTION_NAME,?MODULE,?LINE}]),
		   mnesia:add_table_copy(?TABLE, Source, StorageType),
		   Tables=mnesia:system_info(tables),
		%   io:format("Tables~p~n",[{Tables,Dest,node(),?FUNCTION_NAME,?MODULE,?LINE}]),
		   mnesia:wait_for_tables(Tables,20*1000),
		   ok;
	       Reason ->
		   Reason
	   end,
    Result.

read_all_record()->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    Result=case Z of
	       {aborted,Reason}->
		   {error,Reason};
	       _->
		   Z
	   end,
    Result.
read_all() ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE)])),
    Result=case Z of
	       {aborted,Reason}->
		   {error,Reason};
	       _->
		   [{Id,Time,Node,Severity,Msg,Module,Function,Line,Args,Status}||
		       {?RECORD,Id,Time,Node,Severity,Msg,Module,Function,Line,Args,Status}<-Z]
	   end,
    Result.

read_record(Object) ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),
		   X#?RECORD.id==Object])),
    Result=case Z of
	       {aborted,Reason}->
		   {error,Reason};
	       [X]->
		   X
	   end,
    Result.

read(Object) ->
    Z=do(qlc:q([X || X <- mnesia:table(?TABLE),
		   X#?RECORD.id==Object])),
    Result=case Z of
	       {aborted,Reason}->
		   {error,Reason};
	       _->
		   [R]=[{Id,Time,Node,Severity,Msg,Module,Function,Line,Args,Status}||
			   {?RECORD,Id,Time,Node,Severity,Msg,Module,Function,Line,Args,Status}<-Z],
		   R
	   end,
    Result.

delete(Object) ->
    F = fun() -> 
		RecordList=[X||X<-mnesia:read({?TABLE,Object}),
			    X#?RECORD.id==Object],
		case RecordList of
		    []->
			mnesia:abort(?TABLE);
		    [S1]->
			mnesia:delete_object(S1) 
		end
	end,
    mnesia:transaction(F).
update_status(Object,NewStatus)->
 F = fun() -> 
	     RecordList=do(qlc:q([X || X <- mnesia:table(?TABLE),
				       X#?RECORD.id==Object])),
	     case RecordList of
		 []->
		     mnesia:abort(?TABLE);
		 [S1]->
		     NewRecord=S1#?RECORD{status=NewStatus},
		     mnesia:delete_object(S1),
		     mnesia:write(NewRecord)
	     end
		 
     end,
    mnesia:transaction(F).
    

do(Q) ->
    F = fun() -> qlc:e(Q) end,
    Result=case mnesia:transaction(F) of
	       {atomic, Val}->
		   Val;
	       Error->
		   Error
	   end,
    Result.

%%--------------------------------------------------------------------
