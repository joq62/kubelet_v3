%% This is the application resource file (.app file) for the 'base'
%% application.
{application, host,
[{description, "Host application and cluster" },
{vsn, "0.1.0" },
{modules, 
	  [host_app,host,host_sup,host_server,lib_host]},
{registered,[host]},
{applications, [kernel,stdlib]},
{mod, {host_app,[]}},
{start_phases, []},
{git_path,"https://github.com/joq62/host.git"}
]}.
