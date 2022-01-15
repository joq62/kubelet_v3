%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lib_bully).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
%-ifdef(unit_test).
%-define(get_nodes(),test_get_nodes()).
%-else.
%-define(get_nodes(),prod_get_nodes()).
%-endif.


%%---------------------------------------------------------------------
%% Records for test
%%

%% --------------------------------------------------------------------
%-compile(export_all).

-export([
	 get_nodes/0
	]).
	 

%% ====================================================================
%% External functions
%% ====================================================================
get_nodes()->
    {ok,BullyApp}=application:get_env(application),
    lists:delete(node(),sd:get(BullyApp)).
  %  lists:delete(node(),sd:get(bully_test)).
