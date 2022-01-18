#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "cmd.h"
#include "serial.h"
#include "pexec.h"

static void check_remote_readyness(FILE* port)
{
    char buffer[80];
    fgets(buffer, sizeof(buffer), port);

    printf("%s", buffer);

    if (strncmp(buffer, "Ready to rock!", 14) != 0)
    {
        exit(1);
    }
}

static void read_remote(FILE* port, struct cmd_options *cmd)
{
    fprintf(port, "sx %s\r\n", cmd->chip);
    fflush(port);

    check_remote_readyness(port);

    char *const read_params[] = {"/usr/bin/rx", "-c", cmd->file, NULL};

    pexec(fileno(port), read_params);
}

static void write_remote(FILE* port, struct cmd_options *cmd)
{
    fprintf(port, "rx %s\r\n", cmd->chip);
    fflush(port);

    check_remote_readyness(port);

    char *const read_params[] = {"/usr/bin/sx", cmd->file, NULL};

    pexec(fileno(port), read_params);
}

static void verify_data(FILE* port, struct cmd_options *cmd)
{
    FILE *local = fopen(cmd->file, "rb");
    if (local == NULL)
    {
        perror("Local file");
        exit(1);
    }

    char tmp_fname[20];

    cmd->file = strcpy(tmp_fname, "tmpXXXXXX");
    int tmp_fd = mkstemp(tmp_fname);
    if (tmp_fd < 0)
    {
        perror("Temp file");
        exit(1);
    }

    read_remote(port, cmd);

    if (unlink(cmd->file) < 0)
    {
        perror("Unlink temp file");
        exit(1);
    }

    FILE *remote = fdopen(tmp_fd, "rb");
    if (remote == NULL)
    {
        perror("Remote file");
        exit(1);
    }

    fprintf(stderr, "Comparing");
    fflush(stderr);

    char lf_buf[1024];
    char rf_buf[1024];

    size_t position = 0;

    for (;;)
    {
        fprintf(stderr, ".");
        fflush(stderr);

        size_t nloc = fread(lf_buf, 1, sizeof(lf_buf), local);
        size_t nrem = fread(rf_buf, 1, sizeof(rf_buf), remote);

        if (nloc != nrem)
        {
            fprintf(stderr, "File sizes differ at block offset %d\n", position);
            exit(1);
        }

        if (memcmp(lf_buf, rf_buf, nloc) != 0)
        {
            fprintf(stderr, "File contents differ at block offset %d\n", position);
            exit(1);
        }

        position += nloc;

        if (nloc < sizeof(lf_buf)) break;
    }

    fclose(local);
    fclose(remote);

    fprintf(stderr, "Success!\n");
}

static FILE *initialize_writer(char *cmd_port)
{
    int port_fd = serial_port_open(cmd_port);
    serial_port_set_speed(port_fd);
    serial_port_reset_arduino(port_fd);

    FILE *port = fdopen(port_fd, "wb+");

    if (port == NULL)
    {
        perror("Port");
        exit(1);
    }

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
    case ACT_VERIFY:
        verify_data(port, &cmd);
        break;
    }

    return 0;
}