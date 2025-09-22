#include "hdb_comm.h"
#include "input_buffer.h"

#include <termios.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/select.h>


static int _channel_fd;
static struct ringbuffer _ringbuffer;


void hdb_setup_comm_lazy(void)
{
    _channel_fd = -1;
}

static void ensure_initialized(void)
{
    if (_channel_fd == -1)
    {
        _channel_fd = channel_open();
        ringbuffer_init(&_ringbuffer, _channel_fd);
    }
}

static int get_channel(void)
{
    ensure_initialized();
    return _channel_fd;
}

static struct ringbuffer *get_ringbuffer(void)
{
    ensure_initialized();
    return &_ringbuffer;
}

int hdb_get_char(void)
{
    struct ringbuffer *rb = get_ringbuffer();

    int val = ringbuffer_read_blocking(rb);

    return val;
}

int hdb_peek_char(void)
{
    struct ringbuffer *rb = get_ringbuffer();

    int val = ringbuffer_peek(rb);

    return val;
}

int hdb_get_int(void)
{
    struct ringbuffer *rb = get_ringbuffer();

    int val = ringbuffer_read_int_blocking(rb);

    return val;
}

void hdb_send_char(int value)
{
    int channel = get_channel();

    int res = write(channel, &value, 1);
    if (res < 0) {
        perror("hdb_send_char");
        exit(EXIT_FAILURE);
    }
}

void hdb_send_int(int value)
{
    char buffer[20];
    int channel = get_channel();

    int nbytes = snprintf(buffer, sizeof(buffer), "%d\n", value);

    if (nbytes < 0) {
        perror("hdb_send_int: snprintf");
        exit(EXIT_FAILURE);
    }

    if (nbytes > (int)sizeof(buffer)) {
        fprintf(stderr, "hdb_send_int: integer too large: %d\n", value);
        exit(EXIT_FAILURE);
    }

    int res = write(channel, buffer, nbytes);
    if (res < 0) {
        perror("hdb_send_int");
        exit(EXIT_FAILURE);
    }
}

void hdb_send_str(const char *value)
{
    char buffer[1024];
    int channel = get_channel();

    int nbytes = snprintf(buffer, sizeof(buffer), "%s\r\n", value);

    if (nbytes < 0) {
        perror("hdb_send_int: snprintf");
        exit(EXIT_FAILURE);
    }

    if (nbytes > (int)sizeof(buffer)) {
        fprintf(stderr, "hdb_send_str: string too long: %s\n", value);
        exit(EXIT_FAILURE);
    }

    int res = write(channel, buffer, nbytes);
    if (res < 0) {
        perror("hdb_send_str");
        exit(EXIT_FAILURE);
    }
}

int hdb_check_input(void)
{
    struct ringbuffer *rb = get_ringbuffer();

    int val = ringbuffer_peek(rb);

    return val != -1;
}

void hdb_discard_char(void)
{
    struct ringbuffer *rb = get_ringbuffer();

    ringbuffer_discard(rb);
}