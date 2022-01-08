#include "serial.h"
#include <stdio.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>

#define BAUDRATE B115200

int serial_port_open(const char* port)
{

    int fd = open(port, O_RDWR | O_NOCTTY);
    if (fd <0) {perror(port); exit(-1); }

    return fd;
}

void serial_port_set_speed(int fd)
{
    struct termios newtio;

    memset(&newtio, 0, sizeof(newtio));
    newtio.c_cflag = BAUDRATE | CRTSCTS | CS8 | CLOCAL | CREAD;
    newtio.c_iflag = IGNPAR;
    newtio.c_oflag = 0;

    /* set input mode (non-canonical, no echo,...) */
    newtio.c_lflag = 0;

    newtio.c_cc[VTIME]    = 0;   /* 5 sec timeout */
    newtio.c_cc[VMIN]     = 1;   /* unused */

    tcflush(fd, TCIFLUSH);
    tcsetattr(fd,TCSANOW,&newtio);
}


void serial_port_reset_arduino(int port_fd)
{
    int flags;
    if (ioctl(port_fd, TIOCMGET, &flags) < 0)
    {
        perror("read flags");
        exit(1);
    }

    flags &= ~TIOCM_DTR;
    if (ioctl(port_fd, TIOCMSET, &flags) < 0)
    {
        perror("set dtr off");
        exit(1);
    }

    sleep(1);

    flags |= TIOCM_DTR;
    if (ioctl(port_fd, TIOCMSET, &flags) < 0)
    {
        perror("set drt on");
        exit(1);
    }
}
