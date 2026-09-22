hdb_comm.vpi: hdb_comm.c registration.c udp_host.c input_buffer.c hdb_messaging.c
	# The iverilog-vpi appears to be buggy on Ubuntu 26.04, so we use plain cc instead
	cc -shared -fPIC -Wall -Wextra -Wshadow -Wstrict-prototypes -g -O2 -Werror=implicit-function-declaration -o hdb_comm.vpi -I/usr/include/iverilog $^

clean:
	rm -f hdb_comm.vpi *.o
