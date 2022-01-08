#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cmd.h"
#include "serial.h"
#include "pexec.h"

static void read_remote(FILE* port, struct cmd_options *cmd)
{
    fprintf(port, "sx %s\r\n", cmd->chip);
    fflush(port);

    char *const read_params[] = {"/usr/bin/rx", "-c", cmd->file, NULL};

    pexec(fileno(port), read_params);
}

static void write_remote(FILE* port, struct cmd_options *cmd)
{
    fprintf(port, "rx %s\r\n", cmd->chip);
    fflush(port);

    char *const read_params[] = {"/usr/bin/sx", cmd->file, NULL};

    pexec(fileno(port), read_params);
}

static FILE *initialize_writer(char *cmd_port)
{
    int port_fd = serial_port_open(cmd_port);
    serial_port_set_speed(port_fd);
    serial_port_reset_arduino(port_fd);

    FILE *port = fdopen(port_fd, "wb+");

    if (port == NULL)
        perror("Port");

    fprintf(stderr, "Waiting for device...");
    fflush(stderr);

    char buffer[80];
    do {
        fgets(buffer, 80, port);
        putc('.', stderr);
        fflush(stderr);
    }
    while (strncmp(buffer, "XMODEM", 6) != 0);
    fprintf(stderr, "%s", buffer);

    return port;
}

int main(int argc, char **argv)
{
    struct cmd_options cmd;

    parse_cmd(argc, argv, &cmd);

    FILE *port = initialize_writer(cmd.port);

    switch (cmd.action)
    {
    case ACT_READ:
        read_remote(port, &cmd);
        break;
    case ACT_WRITE:
        write_remote(port, &cmd);
        break;
    }

    return 0;
}