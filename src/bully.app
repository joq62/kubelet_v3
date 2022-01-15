%% This is the application resource file (.app file) for the 'base'
%% application.
{application, bully,
[{description, "Bully application and cluster" },
{vsn, "0.1.0" },
{modules, 
	  [bully_app,bully,bully_sup,bully_server,lib_bully]},
{registered,[bully]},
{applications, [kernel,stdlib]},
{mod, {bully_app,[]}},
{start_phases, []},
{git_path,"https://github.com/joq62/bully.git"}
]}.
