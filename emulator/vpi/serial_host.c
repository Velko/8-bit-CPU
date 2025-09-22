#include "hdb_comm.h"
#include "input_buffer.h"

#include <termios.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/select.h>



#define BAUDRATE B115200
#define MODEMDEVICE "/tmp/cpu8pty1"


int channel_open(void)
{
    struct termios newtio;

    int fd = open(MODEMDEVICE, O_RDWR | O_NOCTTY );
    if (fd <0) {perror(MODEMDEVICE); exit(-1); }

    memset(&newtio, 0, sizeof(newtio));
    newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;
    newtio.c_iflag = 0;
    newtio.c_oflag = 0;

    /* set input mode (non-canonical, no echo,...) */
    newtio.c_lflag = 0;

    newtio.c_cc[VTIME]    = 0;   /* no timeout */
    newtio.c_cc[VMIN]     = 1;   /* at least 1 byte received */

    tcflush(fd, TCIFLUSH);
    tcsetattr(fd,TCSANOW,&newtio);

    return fd;
}

int channel_send(int fd, const void *buf, size_t len)
{
    return write(fd, buf, len);
}

int channel_receive(int fd, void *buf, size_t len)
{
    return read(fd, buf, len);
}

void channel_close(int fd)
{
    close(fd);
}