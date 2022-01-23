#include "serial_host.h"

#include <termios.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <string>
#include <iostream>
#include <unistd.h>



#define BAUDRATE B115200
#define MODEMDEVICE "pty1"


void open_serial()
{
    struct termios newtio;

    int fd = open(MODEMDEVICE, O_RDWR | O_NOCTTY );
    if (fd <0) {perror(MODEMDEVICE); exit(-1); }

    memset(&newtio, 0, sizeof(newtio));
    newtio.c_cflag = BAUDRATE | CRTSCTS | CS8 | CLOCAL | CREAD;
    newtio.c_iflag = IGNPAR;
    newtio.c_oflag = 0;

    /* set input mode (non-canonical, no echo,...) */
    newtio.c_lflag = 0;

    newtio.c_cc[VTIME]    = 0;   /* no timeout */
    newtio.c_cc[VMIN]     = 1;   /* at least 1 byte received */

    tcflush(fd, TCIFLUSH);
    tcsetattr(fd,TCSANOW,&newtio);

    serial = fdopen(fd, "ab+");
}

FILE *serial;
