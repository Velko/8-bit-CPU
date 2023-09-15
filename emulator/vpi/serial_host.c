#include "serial_host.h"

#include <termios.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>



#define BAUDRATE B115200
#define MODEMDEVICE "pty1"

FILE *serial;

void open_serial(void)
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

int serial_get_cmd(void)
{
    int val = fgetc(serial);

    if (val < 0) {
        perror("serial_get_cmd");
        exit(EXIT_FAILURE);
    }

    return val;
}

int serial_get_arg(void)
{
    int val;
    int res = fscanf(serial, "%d", &val);

    if (res == EOF) {
        if (ferror(serial)) {
            perror("serial_get_arg");
            exit(EXIT_FAILURE);
        }
        return 0;
    } else if (res == 0) {
        fprintf(stderr, "Protocol mismatch: integer argument expected\n");
        exit(EXIT_FAILURE);
    }

    return val;
}

void serial_send_int(int value)
{
    int res = fprintf(serial, "%d\n", value);
    if (res < 0) {
        perror("serial_send_int");
        exit(EXIT_FAILURE);
    }
}

void serial_send_str(const char *value)
{
    int res = fprintf(serial, "%s\r\n", value);
    if (res < 0) {
        perror("serial_send_int");
        exit(EXIT_FAILURE);
    }
}
