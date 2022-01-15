%% Author: uabjle
%% Created: 10 dec 2012
%% Description: TODO: Add description to application_org
-module(sd). 

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Definitions 
%% --------------------------------------------------------------------
-define(SERVER,sd_server).
%% --------------------------------------------------------------------
-export([
	 call/5,
	 cast/4,
	 all/0,
	 get/1,
	 get/2,
	 ping/0
        ]).

-export([
	 boot/0,
	 start/0,
	 stop/0
	]).



%% ====================================================================
%% External functions
%% ====================================================================

%% Asynchrounus Signals
boot()->
    ok=application:start(?MODULE).
%% Gen server functions

start()-> gen_server:start_link({local, ?SERVER}, ?SERVER, [], []).
stop()-> gen_server:call(?SERVER, {stop},infinity).




%%---------------------------------------------------------------
-spec ping()-> {atom(),node(),module()}|{atom(),term()}.
%% 
%% @doc:check if service is running
%% @param: non
%% @returns:{pong,node,module}|{badrpc,Reason}
%%
ping()-> 
    gen_server:call(?SERVER, {ping},infinity).


call(App,M,F,A,T)-> 
    gen_server:call(?SERVER, {call,App,M,F,A,T},infinity).
cast(App,M,F,A)-> 
    gen_server:call(?SERVER, {cast,App,M,F,A},infinity).

get(WantedApp)->
    gen_server:call(?SERVER, {get,WantedApp},infinity).
    
get(WantedApp,WantedNode)->
    gen_server:call(?SERVER, {get,WantedApp,WantedNode},infinity).
    
all()->
    gen_server:call(?SERVER, {all},infinity).



%%----------------------------------------------------------------------
