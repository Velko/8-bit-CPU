#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include "input_buffer.h"
#include "hdb_comm.h"

/* Circular buffer, that is filled with data read from FD by helper thread.
   It provides both blocking, non-blocking reads. There's also integer parsing
   for easier PinControl interface. Non-blocking routines helps to implement
   UART emulator.
 */

#define BUFFER_MASK     (BUFFER_SIZE - 1)
#define WRAP(X)         ((X) & BUFFER_MASK)

static void ringbuffer_write(struct ringbuffer *buffer, char c);

static void *filler(void *arg)
{
    struct ringbuffer *queue = arg;
    char buffer[BUFFER_SIZE];

    for (;;)
    {
        int r = channel_receive(queue->source_fd, buffer, sizeof(buffer));
        if (r < 0) {
            perror("ringbuffer filler: read");
            exit(EXIT_FAILURE);
        }
        if (r == 0) break; /* EOF */
        for (int i = 0; i < r; i++)
            ringbuffer_write(queue, buffer[i]);
    }

    channel_close(queue->source_fd);

    return NULL;
}

void ringbuffer_init(struct ringbuffer *buffer, int source_fd)
{
    buffer->read_index = 0;
    buffer->write_index = 0;
    buffer->source_fd = source_fd;

    pthread_create(&buffer->fill_thread, NULL, &filler, buffer);
    pthread_mutex_init(&buffer->indices_mutex, NULL);
    pthread_cond_init(&buffer->empty_cond, NULL);
    pthread_cond_init(&buffer->full_cond, NULL);
}

static bool ringbuffer_isempty(struct ringbuffer *buffer)
{
    return buffer->read_index == buffer->write_index;
}

static bool ringbuffer_isfull(struct ringbuffer *buffer)
{
    return buffer->read_index != buffer->write_index
        && WRAP(buffer->read_index) == WRAP(buffer->write_index);
}

static void ringbuffer_write(struct ringbuffer *buffer, char c)
{
    pthread_mutex_lock(&buffer->indices_mutex);

    /* check/wait until buffer becomes non-full */
    while (ringbuffer_isfull(buffer))
        pthread_cond_wait(&buffer->full_cond, &buffer->indices_mutex);

    buffer->data[WRAP(buffer->write_index++)] = c;

    /* signal that buffer is not empty anymore */
    pthread_cond_signal(&buffer->empty_cond);
    pthread_mutex_unlock(&buffer->indices_mutex);
}

int ringbuffer_read_blocking(struct ringbuffer *buffer)
{
    pthread_mutex_lock(&buffer->indices_mutex);

    /* check/wait for buffer to become non-empty */
    while (ringbuffer_isempty(buffer))
        pthread_cond_wait(&buffer->empty_cond, &buffer->indices_mutex);

    int result = buffer->data[WRAP(buffer->read_index++)];

    /* signal that buffer is not full anymore */
    pthread_cond_signal(&buffer->full_cond);

    pthread_mutex_unlock(&buffer->indices_mutex);
    return result;
}

int ringbuffer_peek(struct ringbuffer *buffer)
{
    pthread_mutex_lock(&buffer->indices_mutex);

    int result = -1; /* return -1 if empty */
    if (!ringbuffer_isempty(buffer))
        result = buffer->data[WRAP(buffer->read_index)];

    pthread_mutex_unlock(&buffer->indices_mutex);
    return result;
}

void ringbuffer_discard(struct ringbuffer *buffer)
{
    pthread_mutex_lock(&buffer->indices_mutex);

    /* discard a char it not empty. If used properly (peeked before) it should
       not be empty. */
    if (!ringbuffer_isempty(buffer))
        buffer->read_index++;

    /* in case it was full, signal that it is not so anymore */
    pthread_cond_signal(&buffer->full_cond);

    pthread_mutex_unlock(&buffer->indices_mutex);
}

static int ringbuffer_peek_blocking(struct ringbuffer *buffer)
{
    pthread_mutex_lock(&buffer->indices_mutex);

    /* wait for new chars to arrive */
    while (ringbuffer_isempty(buffer))
        pthread_cond_wait(&buffer->empty_cond, &buffer->indices_mutex);

    int result = buffer->data[WRAP(buffer->read_index)];

    pthread_mutex_unlock(&buffer->indices_mutex);
    return result;
}

static int ringbuffer_discard_and_peek_next_blocking(struct ringbuffer *buffer)
{
    pthread_mutex_lock(&buffer->indices_mutex);

    /* discard a char it not empty. If used properly (peeked before) it should
       not be empty. */
    if (!ringbuffer_isempty(buffer))
        buffer->read_index++;

    /* in case it was full, signal that it is not so anymore */
    pthread_cond_signal(&buffer->full_cond);

    /* if (after discarding the char it became) empty, wait for new chars to
       arrive */
    while (ringbuffer_isempty(buffer))
        pthread_cond_wait(&buffer->empty_cond, &buffer->indices_mutex);

    int result = buffer->data[WRAP(buffer->read_index)];

    pthread_mutex_unlock(&buffer->indices_mutex);
    return result;
}


#define NUMBUF_SIZE   16

int ringbuffer_read_int_blocking(struct ringbuffer *buffer)
{
    char numbuf[NUMBUF_SIZE];
    int cidx = 0;

    int c = ringbuffer_peek_blocking(buffer);
    while (((c >= '0' && c <= '9') || c == '-') && cidx < NUMBUF_SIZE-1)
    {
        numbuf[cidx++] = c;
        c = ringbuffer_discard_and_peek_next_blocking(buffer);
    }
    numbuf[cidx] = 0;

    return strtol(numbuf, NULL, 0);
}
