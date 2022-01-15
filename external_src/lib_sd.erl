%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lib_sd).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%%---------------------------------------------------------------------
%% Records for test
%%

%% --------------------------------------------------------------------
%-compile(export_all).
-export([
	 call/5,
	 cast/4,
	 all/0,
	 get/1,
	 get/2
	]).


%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
call(App,M,F,A,T)->
    Result=case rpc:call(node(),sd,get,[App],T) of
	       {badrpc,Reason}->
		   {error,[{badrpc,Reason}]};
	       []->
		   [];
	       [Node|_]->
		   rpc:call(Node,M,F,A,T)
	   end,
    Result.

	%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
cast(App,M,F,A)->
    Result=case rpc:call(node(),sd,get,[App],5*1000) of
	       {badrpc,Reason}->
		   {badrpc,Reason};
	       []->
		   {error,[eexists,App,?FUNCTION_NAME,?MODULE,?LINE]};
	       [Node|_]->
		   rpc:cast(Node,M,F,A)
	   end,
    Result.			   

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
all()->
    Apps=[{Node,rpc:call(Node,application,loaded_applications,[],5*1000)}||Node<-[node()|nodes()]],
    AvailableNodes=[{Node,AppList}||{Node,AppList}<-Apps,
				    AppList/={badrpc,nodedown}],
    AvailableNodes.
    

get(WantedApp)->
    Apps=[{Node,rpc:call(Node,application,loaded_applications,[],5*1000)}||Node<-[node()|nodes()]],
    AvailableNodes=[Node||{Node,AppList}<-Apps,
			  AppList/={badrpc,nodedown},
			  AppList/={badrpc,timeout},
			  true==lists:keymember(WantedApp,1,AppList)],
    AvailableNodes.

get(WantedApp,WantedNode)->

    Apps=[{Node,rpc:call(Node,application,loaded_applications,[],5*1000)}||Node<-[node()|nodes()]],
    AvailableNodes=[WantedNode||{Node,AppList}<-Apps,
				AppList/={badrpc,nodedown},
				AppList/={badrpc,timeout},
				true==lists:keymember(WantedApp,1,AppList),
				Node==WantedNode],
    AvailableNodes.

