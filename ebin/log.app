%% This is the application resource file (.app file) for the 'base'
%% application.
{application, log,
[{description, "Log application and cluster" },
{vsn, "1.0.0" },
{modules, 
	  [log_app,log_sup,log,log_server]},
{registered,[log]},
{applications, [kernel,stdlib]},
{mod, {log_app,[]}},
{start_phases, []},
{git_path,"https://github.com/joq62/log_server.git"}
]}.
