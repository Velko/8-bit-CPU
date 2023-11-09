#include "serial_host.h"
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

static FILE *_serial_out;
static struct ringbuffer _ringbuffer;


void setup_serial_lazy(void)
{
    _serial_out = NULL;
}

static int open_serial(void)
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

static void ensure_initialized(void)
{
    if (_serial_out == NULL)
    {
        int fd = open_serial();
        _serial_out = fdopen(fd, "ab");
        ringbuffer_init(&_ringbuffer, fd);
    }
}

static FILE *get_serial(void)
{
    ensure_initialized();
    return _serial_out;
}

static struct ringbuffer *get_ringbuffer(void)
{
    ensure_initialized();
    return &_ringbuffer;
}

int serial_get_char(void)
{
    struct ringbuffer *rb = get_ringbuffer();

    int val = ringbuffer_read_blocking(rb);

    return val;
}

int serial_peek_char(void)
{
    struct ringbuffer *rb = get_ringbuffer();

    int val = ringbuffer_peek(rb);

    return val;
}

int serial_get_int(void)
{
    struct ringbuffer *rb = get_ringbuffer();

    int val = ringbuffer_read_int_blocking(rb);

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
    struct ringbuffer *rb = get_ringbuffer();

    int val = ringbuffer_peek(rb);

    return val != -1;
}

void serial_discard_char(void)
{
    struct ringbuffer *rb = get_ringbuffer();

    ringbuffer_discard(rb);
}