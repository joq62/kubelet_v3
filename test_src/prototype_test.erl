%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  1
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(prototype_test).   
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("log.hrl").
%% --------------------------------------------------------------------

%% External exports
-export([start/0]). 


%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
start()->
  %  io:format("~p~n",[{"Start setup",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=setup(),
    io:format("~p~n",[{"Stop setup",?MODULE,?FUNCTION_NAME,?LINE}]),

%    io:format("~p~n",[{"Start init()",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=init(),
    io:format("~p~n",[{"Stop init()",?MODULE,?FUNCTION_NAME,?LINE}]),

  %  io:format("~p~n",[{"Start stop_restart()",?MODULE,?FUNCTION_NAME,?LINE}]),
  %  ok= stop_restart(),
  %  io:format("~p~n",[{"Stop  stop_restart()",?MODULE,?FUNCTION_NAME,?LINE}]),

 %   
      %% End application tests
  %  io:format("~p~n",[{"Start cleanup",?MODULE,?FUNCTION_NAME,?LINE}]),
    ok=cleanup(),
  %  io:format("~p~n",[{"Stop cleaup",?MODULE,?FUNCTION_NAME,?LINE}]),
   
    io:format("------>"++atom_to_list(?MODULE)++" ENDED SUCCESSFUL ---------"),
    ok.
 %  io:format("application:which ~p~n",[{application:which_applications(),?FUNCTION_NAME,?MODULE,?LINE}]),

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
init()->
    
    [N0,N1,N2]=test_nodes:get_nodes(),
    io:format("read_all ~p~n",[{rpc:call(N0,catalog,get_all,[],10*1000),?FUNCTION_NAME,?MODULE,?LINE}]),
    io:format("read_all ~p~n",[{rpc:call(N1,catalog,get_all,[],10*1000),?FUNCTION_NAME,?MODULE,?LINE}]),
    io:format("read_all ~p~n",[{rpc:call(N2,catalog,get_all,[],10*1000),?FUNCTION_NAME,?MODULE,?LINE}]),
 %   R1=rpc:call(N0,mnesia,load_textfile,["catalog.config"],10*1000),
 %   io:format("R1 ~p~n",[{R1,?FUNCTION_NAME,?MODULE,?LINE}]),
  %  io:format("mnesia,system_info ~p~n",[{rpc:call(N0,mnesia,system_info,[],10*1000),?FUNCTION_NAME,?MODULE,?LINE}]),
    io:format("read_all ~p~n",[{rpc:call(N0,db_host,read_all,[],10*1000),?FUNCTION_NAME,?MODULE,?LINE}]),
    io:format("read_all ~p~n",[{rpc:call(N1,db_host,read_all,[],10*1000),?FUNCTION_NAME,?MODULE,?LINE}]),
    io:format("read_all ~p~n",[{rpc:call(N2,db_host,read_all,[],10*1000),?FUNCTION_NAME,?MODULE,?LINE}]),
  
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------



  
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
a()->
    						

    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
setup()->
    
        
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------    

cleanup()->
   
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
