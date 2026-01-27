#ifndef INPUT_BUFFER_H
#define INPUT_BUFFER_H

#include <pthread.h>

#define BUFFER_SIZE     1024  /* only power-of-two allowed */

struct ringbuffer
{
    char data[BUFFER_SIZE];
    unsigned read_index;
    unsigned write_index;

    pthread_t fill_thread;
    pthread_mutex_t indices_mutex;
    pthread_cond_t empty_cond;
    pthread_cond_t full_cond;
    int source_fd;
};

void ringbuffer_init(struct ringbuffer *buffer, int source_fd);
int ringbuffer_read_blocking(struct ringbuffer *buffer);
int ringbuffer_peek(struct ringbuffer *buffer);
int ringbuffer_read_int_blocking(struct ringbuffer *buffer);
void ringbuffer_discard(struct ringbuffer *buffer);

struct ringbuffer *ringbuffer_get(void);

#endif /* INPUT_BUFFER_H */
