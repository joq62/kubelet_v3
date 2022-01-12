%% This is the application resource file (.app file) for the 'base'
%% application.
{application, kubelet,
[{description, "Kubelet application and cluster" },
{vsn, "1.0.0" },
{modules, 
	  [kubelet_app,kubelet_sup,kubelet,kubelet_server,
	   lib_sd,sd,sd_server,
	   lib_dbase,dbase,dbase_server,
	   lib_bully,bully,bully_server,
	   lib_log,db_log,log,log_server]},
{registered,[kubelet]},
{applications, [kernel,stdlib]},
{mod, {kubelet_app,[]}},
{start_phases, []},
{git_path,"https://github.com/joq62/kubelet.git"}
]}.
