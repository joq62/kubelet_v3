%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : resource discovery accroding to OPT in Action 
%%% This service discovery is adapted to 
%%% Type = application 
%%% Instance ={ip_addr,{IP_addr,Port}}|{erlang_node,{ErlNode}}
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(dbase_server).

-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("log.hrl").
%% --------------------------------------------------------------------

-define(ScheduleInterval,1*10*1000).

%% External exports
-export([
	 schedule/0
	]).


%% gen_server callbacks



-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {loaded,
		spec_list
	       }).

%% ====================================================================
%% External functions
%% ====================================================================


schedule()->
    gen_server:cast(?MODULE, {schedule}).

%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
  %  io:format("#1 ~p~n",[{?FUNCTION_NAME,?MODULE,?LINE}]),
    {ok,DbaseApplication}=application:get_env(application),
    DbaseAppNodes=lists:delete(node(),sd:get(DbaseApplication)),
    ok=lib_dbase:dynamic_db_init(DbaseAppNodes),
    
    rpc:cast(node(),log,log,[?Log_info("server started",[])]),
    {ok, #state{}}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call({dynamic_db_init,DbaseNodeList},_From, State) ->
    Reply=rpc:call(node(),lib_dbase,dynamic_db_init,[DbaseNodeList],5*1000),
    {reply, Reply, State};

handle_call({dynamic_add_table,Table,StorageType},_From, State) ->
    Reply=rpc:call(node(),lib_dbase,dynamic_add_table,[Table,StorageType],5*1000),
    {reply, Reply, State};

handle_call({load_textfile,TableTextFiles},_From, State) ->
    Reply=rpc:call(node(),lib_dbase,load_textfile,[TableTextFiles],5*1000),
    {reply, Reply, State};

handle_call({ping},_From, State) ->
    Reply=pong,
    {reply, Reply, State};



handle_call({stop}, _From, State) ->
    mnesia:stop(),
    mnesia:del_table_copy(schema,node()),
    mnesia:delete_schema([node()]),
    {stop, normal, shutdown_ok, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{Msg,?MODULE,?LINE}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
    io:format("unmatched match~p~n",[{Info,?MODULE,?LINE}]), 
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
