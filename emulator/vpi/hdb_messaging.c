#include "hdb_comm.h"
#include "input_buffer.h"

#include <termios.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/select.h>


struct comm_channel {
    int fd;
    struct ringbuffer ringbuffer;
    uint16_t remote_port;
};

static struct comm_channel _channels[NUM_CHANNELS];

void hdb_setup_comm(void)
{
    for (int i = 0; i < NUM_CHANNELS; i++) {
        _channels[i].remote_port = 0;
        _channels[i].fd = channel_open(i);
        ringbuffer_init(&_channels[i].ringbuffer, _channels[i].fd);
    }
}

static struct comm_channel *get_channel(int endpoint)
{
    if (endpoint < 0 || endpoint >= NUM_CHANNELS) {
        fprintf(stderr, "Invalid endpoint: %d\n", endpoint);
        exit(EXIT_FAILURE);
    }
    return &_channels[endpoint];
}

int hdb_get_char(int endpoint)
{
    struct comm_channel *channel = get_channel(endpoint);

    int val = ringbuffer_read_blocking(&channel->ringbuffer);

    return val;
}

int hdb_peek_char(int endpoint)
{
    struct comm_channel *channel = get_channel(endpoint);

    int val = ringbuffer_peek(&channel->ringbuffer);

    return val;
}

int hdb_get_int(int endpoint)
{
    struct comm_channel *channel = get_channel(endpoint);

    int val = ringbuffer_read_int_blocking(&channel->ringbuffer);

    return val;
}

void hdb_send_char(int endpoint, int value)
{
    struct comm_channel *channel = get_channel(endpoint);

    int res = channel_send(channel->fd, channel->remote_port, &value, 1);
    if (res < 0) {
        perror("hdb_send_char");
        exit(EXIT_FAILURE);
    }
}

void hdb_send_int(int endpoint, int value)
{
    char buffer[20];
    struct comm_channel *channel = get_channel(endpoint);

    int nbytes = snprintf(buffer, sizeof(buffer), "%x\n", value);

    if (nbytes < 0) {
        perror("hdb_send_int: snprintf");
        exit(EXIT_FAILURE);
    }

    if (nbytes > (int)sizeof(buffer)) {
        fprintf(stderr, "hdb_send_int: integer too large: %x\n", value);
        exit(EXIT_FAILURE);
    }

    int res = channel_send(channel->fd, channel->remote_port, buffer, nbytes);
    if (res < 0) {
        perror("hdb_send_int");
        exit(EXIT_FAILURE);
    }
}

void hdb_send_str(int endpoint, const char *value)
{
    char buffer[1024];
    struct comm_channel *channel = get_channel(endpoint);

    int nbytes = snprintf(buffer, sizeof(buffer), "%s\r\n", value);

    if (nbytes < 0) {
        perror("hdb_send_str: snprintf");
        exit(EXIT_FAILURE);
    }

    if (nbytes > (int)sizeof(buffer)) {
        fprintf(stderr, "hdb_send_str: string too long: %s\n", value);
        exit(EXIT_FAILURE);
    }

    int res = channel_send(channel->fd, channel->remote_port, buffer, nbytes);
    if (res < 0) {
        perror("hdb_send_str");
        exit(EXIT_FAILURE);
    }
}

int hdb_check_input(int endpoint)
{
    struct comm_channel *channel = get_channel(endpoint);

    int val = ringbuffer_peek(&channel->ringbuffer);

    return val != -1;
}

void hdb_discard_char(int endpoint)
{
    struct comm_channel *channel = get_channel(endpoint);

    ringbuffer_discard(&channel->ringbuffer);
}


void hdb_register_endpoint(int endpoint, uint16_t port)
{
    struct comm_channel *channel = get_channel(endpoint);

    channel->remote_port = port;
}
