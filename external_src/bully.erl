%% Author: uabjle
%% Created: 10 dec 2012
%% Description: TODO: Add description to application_org
-module(bully). 

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Behavioural exports
%% --------------------------------------------------------------------
-export([
	 status/0,
	 election_message/1,
	 election_response/0,
	 election_timeout/1,
	 coordinator_message/1,
	 start_election/0,
	 who_is_leader/0,
	 am_i_leader/1,
	 ping/0
	]).

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------
-export([start/0,
	 stop/0]).
%% --------------------------------------------------------------------
%% Macros
%% --------------------------------------------------------------------
-define(SERVER,bully_server).
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
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Func: start/2
%% Returns: {ok, Pid}        |
%%          {ok, Pid, State} |
%%          {error, Reason}
%% --------------------------------------------------------------------


start()-> gen_server:start_link({local, ?SERVER}, ?SERVER, [], []).
stop()-> gen_server:call(?SERVER, {stop},infinity).
ping()-> gen_server:call(?SERVER, {ping},infinity).

status()->
    gen_server:call(?SERVER,{status},infinity).

who_is_leader()->
    gen_server:call(?SERVER,{who_is_leader},infinity).
am_i_leader(CallingNode)->
    gen_server:call(?SERVER,{am_i_leader,CallingNode},infinity).
   
election_message(CoordinatorNode)->
     gen_server:cast(?SERVER,{election_message,CoordinatorNode}).
election_response()->
     gen_server:cast(?SERVER,{election_response}).
election_timeout(PidTimeout)->
    gen_server:cast(?SERVER,{election_timeout,PidTimeout}).
coordinator_message(CoordinatorNode)->
     gen_server:cast(?SERVER,{coordinator_message,CoordinatorNode}).

start_election()->
    gen_server:cast(?SERVER,{start_election}).


%% ====================================================================
%% Internal functions
%% ====================================================================

