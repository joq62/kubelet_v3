%% This is the application resource file (.app file) for the 'base'
%% application.
{application, dbase,
[{description, "Dbase application and cluster" },
{vsn, "0.1.0" },
{modules, 
	  [dbase_app,dbase,dbase_sup,dbase_server,lib_dbase]},
{registered,[dbase]},
{applications, [kernel,stdlib]},
{mod, {dbase_app,[]}},
{start_phases, []},
{git_path,"https://github.com/joq62/dbase.git"}
]}.
