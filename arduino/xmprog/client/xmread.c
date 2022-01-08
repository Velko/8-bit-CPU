#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "serial.h"
#include "pexec.h"


int main()
{
    int port_fd = serial_port_open("/dev/ttyACM0");
    //int port_fd = open_port("/dev/pts/5");
    //int port_fd = open_port("../pty0");

    serial_port_set_speed(port_fd);
    serial_port_reset_arduino(port_fd);


    FILE *port = fdopen(port_fd, "wb+");

    if (port == NULL)
        perror("Port");

    char buffer[80];

    fprintf(stderr, "Waiting for device");
    fflush(stderr);

    do {
        fgets(buffer, 80, port);
        putc('.', stderr);
        fflush(stderr);
    }
    while (strncmp(buffer, "XMODEM", 6) != 0);
    fprintf(stderr, "\n%s", buffer);

    fprintf(stderr, "Issue remote send command");
    fflush(stderr);


    fprintf(port, "sx desas.bin\r\n");
    fflush(port);

    char *const params[] = {"/usr/bin/rx", "-c", "mans.bin", NULL};

    pexec(port_fd, params);

    return 0;
}
