%% This is the application resource file (.app file) for the 'base'
%% application.
{application, kubelet,
[{description, "Kubelet application and cluster" },
{vsn, "1.0.0" },
{modules, 
	  [kubelet_app,kubelet_sup,kubelet,kubelet_server]},
{registered,[kubelet,sd,dbase,bully,log]},
{included_applications, [sd,dbase,bully,log]},
{applications, [kernel,stdlib]},
{mod, {kubelet_app,[]}},
{start_phases, []},
{git_path,"https://github.com/joq62/kubelet.git"}
]}.
