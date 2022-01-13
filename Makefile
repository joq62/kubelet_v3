all:
#	service
	rm -rf ebin/* *_ebin;
	rm -rf src/*.beam *.beam  test_src/*.beam test_ebin;
	rm -rf  *~ */*~  erl_cra* *.config;
	rm -rf *.log;
#	common
#	cp ../common/src/*.app ebin;
	erlc -I ../log_server/include -o ebin ../../common/src/*.erl;
#	sd
	erlc -I ../log_server/include -o ebin ../sd/src/*.erl;
#	dbase
	erlc -I ../log_server/include -o ebin ../dbase_server/src/*.erl;
#	log
	erlc -I ../log_server/include -o ebin ../log_server/src/*.erl;
#	bully
	erlc -I ../log_server/include -o ebin ../bully_server/src/*.erl;
#	catalog
	erlc -I ../log_server/include -o ebin ../catalog_server/src/*.erl;
#	app
	cp src/*.app ebin;
	erlc -I ../log_server/include -I include -o ebin src/*.erl;
	echo Done
unit_test:
	rm -rf ebin/* src/*.beam *.beam test_src/*.beam test_ebin;
	rm -rf  *~ */*~  erl_cra* *.text_file *.config;
	mkdir test_ebin;
#	common
#	cp ../common/src/*.app ebin;
	erlc -D unit_test -I ../log_server/include -o ebin ../../common/src/*.erl;
#	sd
	erlc -D unit_test -I ../log_server/include -o ebin ../sd/src/*.erl;
#	dbase
	erlc -D unit_test -I ../log_server/include -o ebin ../dbase_server/src/*.erl;
#	log
	erlc -D unit_test -I ../log_server/include -o ebin ../log_server/src/*.erl;
#	bully
	erlc -D unit_test -I ../log_server/include -o ebin ../bully_server/src/*.erl;
#	catalog
	cp ../catalog_server/include/catalog.config .;
#	cp ../catalog_server/include/host.config .;	
	erlc -D unit_test -I ../log_server/include -o ebin ../catalog_server/src/*.erl;
#	app
	cp src/*.app ebin;
	erlc -D unit_test -I ../log_server/include -I include -o ebin src/*.erl;
#	test application
	cp test_src/*.app test_ebin;
	erlc -D debug_flag -I ../log_server/include -I include -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin\
	    -setcookie cookie_test\
	    -sname kubelet\
	    -unit_test monitor_node test\
	    -unit_test cluster_id test\
	    -unit_test cookie cookie_test\
	    -run unit_test start_test test_src/test.config
