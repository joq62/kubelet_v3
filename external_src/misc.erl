%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(misc).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%%---------------------------------------------------------------------
%% Records for test
%%

%% --------------------------------------------------------------------
%-compile(export_all).
-export([node/1,
	 vmid_hostid/1,
	 rm_duplicates/1
	]).
	 

%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
rm_duplicates(List)->
   lists:reverse(rm_duplicates(List,[])).
rm_duplicates([],SingleList)->
    SingleList;
rm_duplicates([{_,_}|T],Acc)->
    rm_duplicates(T,Acc);
rm_duplicates([Term|T],Acc)->
    NewAcc=case lists:member(Term,T) of
	       false->
		   [Term|Acc];
	       true->
		   Acc
	   end,
    rm_duplicates(T,NewAcc).


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
node(Name)->
    {ok,HostId}=net:gethostname(),
    list_to_atom(Name++"@"++HostId).
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
vmid_hostid(Node)->
    NodeStr=atom_to_list(Node),
    [VmId,HostId]=string:lexemes(NodeStr,"@"),
    {VmId,HostId}.
