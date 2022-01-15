all:
#	service
	rm -rf ebin/* *_ebin;
	rm -rf external_src/* external_include/*;
	rm -rf src/*.beam *.beam  test_src/*.beam test_ebin;
	rm -rf  *~ */*~  erl_cra*;
#
	cp ../../common/src/*.erl external_src;
	cp ../sd/src/*.erl external_src;
	cp ../bully_server/src/*.erl external_src;
	cp ../dbase_server/src/*.erl external_src;
	cp ../bully_server/src/*.erl external_src;
	cp ../log_server/include/* external_include;
	cp ../log_server/src/*.erl external_src;
#	external
	erlc -I include -I external_include -o ebin external_src/*.erl;
#	kubelet
	cp src/*.app ebin;
	erlc -I ../log_server/include -o ebin src/*.erl;
	echo Done
unit_test:
	rm -rf ebin/* src/*.beam *.beam test_src/*.beam test_ebin;
	rm -rf external_src/* external_include/*;
	rm -rf  *~ */*~  erl_cra*;
	mkdir test_ebin;
#	common
	cp ../../common/src/*.erl external_src;
#	erlc -D unit_test -I include -o ebin ../common/src/*.erl;
#	sd
	cp ../sd/src/*.erl external_src;
#	erlc -D unit_test -o ebin ../sd/src/*.erl;
#	bully_server
	cp ../bully_server/src/*.erl external_src;
#	dbase_server
	cp ../dbase_server/src/*.erl external_src;
#	erlc -D unit_test -I include -o ebin ../infra/dbase_server/src/*.erl;
#	log_server
	cp ../log_server/include/* external_include;
	cp ../log_server/src/*.erl external_src;
#	external
	erlc -D unit_test -I include -I external_include -o ebin external_src/*.erl;
#	basic
	cp src/*.app ebin;
	erlc -D unit_test -I include -o ebin src/*.erl;
#	test application
	cp test_src/*.app test_ebin;
	erlc -D debug_flag -I include -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin\
	    -setcookie cookie_test\
	    -sname test\
	    -unit_test monitor_node test\
	    -unit_test cluster_id test\
	    -unit_test cookie cookie_test\
	    -run unit_test start_test test_src/test.config
