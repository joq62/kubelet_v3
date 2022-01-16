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
-include("log.hrl").
%% --------------------------------------------------------------------
%-compile(export_all).

-export([
	 get_nodes/0
	]).
	 

%% ====================================================================
%% External functions
%% ====================================================================
get_nodes()->
    {ok,KubeletNodes}=application:get_env(kubelet_nodes),
    case  [Node||Node<-KubeletNodes,
		 pong=:=net_adm:ping(Node)] of
	[]->
	    rpc:cast(node(),log,log,[?Log_info("no kubelet nodes ",[])]),
	    [];
	Nodes ->
	    Nodes
    end.
  % lists:delete(node(),sd:get(BullyApp)).
  %  lists:delete(node(),sd:get(bully_test)).
