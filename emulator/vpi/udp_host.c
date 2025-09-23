#include "hdb_comm.h"
#include "input_buffer.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

#define LISTEN_PORT 8888
#define RESPOND_PORT 9999

int channel_open(void)
{
    // create an udp socket and bind it to LISTEN_PORT
    int fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd < 0) {
        perror("socket");
        exit(EXIT_FAILURE);
    }
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = htons(LISTEN_PORT);
    if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("bind");
        exit(EXIT_FAILURE);
    }

    return fd;
}

int channel_send(int fd, const void *buf, size_t len)
{
    struct sockaddr_in dest_addr;
    memset(&dest_addr, 0, sizeof(dest_addr));
    dest_addr.sin_family = AF_INET;
    dest_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    dest_addr.sin_port = htons(RESPOND_PORT);

    return sendto(fd, buf, len, 0, (struct sockaddr *)&dest_addr, sizeof(dest_addr));
}

int channel_receive(int fd, void *buf, size_t len)
{
    struct sockaddr_in src_addr;
    socklen_t addrlen = sizeof(src_addr);
    int r = recvfrom(fd, buf, len, 0, (struct sockaddr *)&src_addr, &addrlen);

    if (r < 0) {
        perror("recvfrom");
        exit(EXIT_FAILURE);
    }

    return r;
}

void channel_close(int fd)
{
    close(fd);
}