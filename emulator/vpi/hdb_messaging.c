#include "hdb_comm.h"
#include "input_buffer.h"

#include <termios.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/select.h>


static int _channel_fds[NUM_CHANNELS];
static struct ringbuffer _ringbuffers[NUM_CHANNELS];


void hdb_setup_comm(void)
{
    for (int i = 0; i < NUM_CHANNELS; i++) {
        _channel_fds[i] = channel_open(i);
        ringbuffer_init(&_ringbuffers[i], _channel_fds[i]);
    }
}

static int get_channel(int endpoint)
{
    return _channel_fds[endpoint];
}

static struct ringbuffer *get_ringbuffer(int endpoint)
{
    return &_ringbuffers[endpoint];
}

int hdb_get_char(int endpoint)
{
    struct ringbuffer *rb = get_ringbuffer(endpoint);

    int val = ringbuffer_read_blocking(rb);

    return val;
}

int hdb_peek_char(int endpoint)
{
    struct ringbuffer *rb = get_ringbuffer(endpoint);

    int val = ringbuffer_peek(rb);

    return val;
}

int hdb_get_int(int endpoint)
{
    struct ringbuffer *rb = get_ringbuffer(endpoint);

    int val = ringbuffer_read_int_blocking(rb);

    return val;
}

void hdb_send_char(int endpoint, int value)
{
    int channel = get_channel(endpoint);

    int res = channel_send(channel, endpoint, &value, 1);
    if (res < 0) {
        perror("hdb_send_char");
        exit(EXIT_FAILURE);
    }
}

void hdb_send_int(int endpoint, int value)
{
    char buffer[20];
    int channel = get_channel(endpoint);

    int nbytes = snprintf(buffer, sizeof(buffer), "%x\n", value);

    if (nbytes < 0) {
        perror("hdb_send_int: snprintf");
        exit(EXIT_FAILURE);
    }

    if (nbytes > (int)sizeof(buffer)) {
        fprintf(stderr, "hdb_send_int: integer too large: %x\n", value);
        exit(EXIT_FAILURE);
    }

    int res = channel_send(channel, endpoint, buffer, nbytes);
    if (res < 0) {
        perror("hdb_send_int");
        exit(EXIT_FAILURE);
    }
}

void hdb_send_str(int endpoint, const char *value)
{
    char buffer[1024];
    int channel = get_channel(endpoint);

    int nbytes = snprintf(buffer, sizeof(buffer), "%s\r\n", value);

    if (nbytes < 0) {
        perror("hdb_send_str: snprintf");
        exit(EXIT_FAILURE);
    }

    if (nbytes > (int)sizeof(buffer)) {
        fprintf(stderr, "hdb_send_str: string too long: %s\n", value);
        exit(EXIT_FAILURE);
    }

    int res = channel_send(channel, endpoint, buffer, nbytes);
    if (res < 0) {
        perror("hdb_send_str");
        exit(EXIT_FAILURE);
    }
}

int hdb_check_input(int endpoint)
{
    struct ringbuffer *rb = get_ringbuffer(endpoint);

    int val = ringbuffer_peek(rb);

    return val != -1;
}

void hdb_discard_char(int endpoint)
{
    struct ringbuffer *rb = get_ringbuffer(endpoint);

    ringbuffer_discard(rb);
}
