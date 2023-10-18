#include "serial_host.h"

#include <termios.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/select.h>



#define BAUDRATE B115200
#define MODEMDEVICE "pty1"

static FILE *_serial;

void setup_serial_lazy(void)
{
    _serial = NULL;
}

static FILE *open_serial(void)
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

    return fdopen(fd, "ab+");
}

static FILE *get_serial(void)
{
    if (_serial == NULL)
        _serial = open_serial();
    return _serial;
}

int serial_get_char(void)
{
    FILE *serial = get_serial();

    int val = fgetc(serial);

    if (val < 0) {
        perror("serial_get_char");
        exit(EXIT_FAILURE);
    }

    return val;
}

int serial_get_int(void)
{
    FILE *serial = get_serial();

    int val;
    int res = fscanf(serial, "%d", &val);

    if (res == EOF) {
        if (ferror(serial)) {
            perror("serial_get_int");
            exit(EXIT_FAILURE);
        }
        return 0;
    } else if (res == 0) {
        fprintf(stderr, "Protocol mismatch: integer argument expected\n");
        exit(EXIT_FAILURE);
    }

    return val;
}

void serial_send_char(int value)
{
    FILE *serial = get_serial();

    int res = fputc(value, serial);
    if (res < 0) {
        perror("serial_send_char");
        exit(EXIT_FAILURE);
    }

    res = fflush(serial);
    if (res < 0) {
        perror("serial_send_char");
        exit(EXIT_FAILURE);
    }
}

void serial_send_int(int value)
{
    FILE *serial = get_serial();

    int res = fprintf(serial, "%d\n", value);
    if (res < 0) {
        perror("serial_send_int");
        exit(EXIT_FAILURE);
    }

    res = fflush(serial);
    if (res < 0) {
        perror("serial_send_int");
        exit(EXIT_FAILURE);
    }
}

void serial_send_str(const char *value)
{
    FILE *serial = get_serial();

    int res = fprintf(serial, "%s\r\n", value);
    if (res < 0) {
        perror("serial_send_str");
        exit(EXIT_FAILURE);
    }

    res = fflush(serial);
    if (res < 0) {
        perror("serial_send_str");
        exit(EXIT_FAILURE);
    }
}

int serial_check_input(void)
{
    FILE *serial = get_serial();

    fd_set read_fd_set;
    struct timeval timeout;
    FD_ZERO(&read_fd_set);
    FD_SET(fileno(serial), &read_fd_set);
    timeout.tv_usec = 0;
    timeout.tv_sec = 0;

    int res = select(FD_SETSIZE, &read_fd_set, NULL, NULL, &timeout);

    if (res < 0) {
        perror("serial_check_input");
        exit(EXIT_FAILURE);
    }

    return res;
}