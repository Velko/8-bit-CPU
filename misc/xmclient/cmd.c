#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>

#include "cmd.h"

static void help(void)
{
    printf("xmclient [options] <action> [file]\n");
    printf("\nOptions are:\n");
    printf("    -p | --port <port>      tty port, programmer is connected to. Defaults to /dev/ttyACM0\n");
    printf("    -c | --chip <chip>      target chip name within programmer (eeprom0, flash)\n");

    printf("\nActions are:\n");
    printf("    list      list chips available\n");
    printf("    read      read chip and store result into [file]\n");
    printf("    write     write data from [file] into target chip\n");
    printf("    verify    compare if data in [file] is the same as on chip\n");
    printf("    erase     erase target chip\n");
}

static void check_file_arg(int optind, int argc, char *action)
{
    if (optind >= argc)
    {
        printf("File argument is mandatory for action '%s'.\n", action);
        exit(1);
    }
}

static void check_chip_arg(char *chip, char *action)
{
    if (chip == NULL)
    {
        printf("Chip argument is mandatory for action '%s'.\n", action);
        exit(1);
    }
}

void parse_cmd(int argc, char **argv, struct cmd_options *cmd)
{
    int c;
    int digit_optind = 0;

    memset(cmd, 0, sizeof(struct cmd_options));

    cmd->port = "/dev/ttyACM0";

    for(;;)
    {
        int option_index = 0;
        static struct option long_options[] = {
            {"port", required_argument, 0, 'p'},
            {"chip", required_argument, 0, 'c'},
            {"help", no_argument, 0, 'h'},
            {0, 0, 0}
        };

        c = getopt_long(argc, argv, "p:c:h", long_options, &option_index);

        if (c == -1) break;

        switch (c)
        {
        case 'p':
            cmd->port = optarg;
            break;
        case 'c':
            cmd->chip = optarg;
            break;
        case 'h':
            help();
            exit(0);
        default:
            printf("Not implemented: %x\n", c);
            exit(1);
        }
    }

    if (optind < argc) {

        char *cmd_action = argv[optind++];

        if (strcmp(cmd_action, "list") == 0)
            cmd->action = ACT_LIST;
        else if (strcmp(cmd_action, "read") == 0)
        {
            check_file_arg(optind, argc, cmd_action);
            check_chip_arg(cmd->chip, cmd_action);
            cmd->action = ACT_READ;
            cmd->file = argv[optind++];
        }
        else if (strcmp(cmd_action, "write") == 0)
        {
            check_file_arg(optind, argc, cmd_action);
            check_chip_arg(cmd->chip, cmd_action);
            cmd->action = ACT_WRITE;
            cmd->file = argv[optind++];
        }
        else if (strcmp(cmd_action, "verify") == 0)
        {
            check_file_arg(optind, argc, cmd_action);
            check_chip_arg(cmd->chip, cmd_action);
            cmd->action = ACT_VERIFY;
            cmd->file = argv[optind++];
        }
        else if (strcmp(cmd_action, "erase") == 0)
        {
            check_chip_arg(cmd->chip, cmd_action);
            cmd->action = ACT_ERASE;
        }
        else
        {
            printf("Unknown action '%s'\n", cmd_action);
            exit(1);
        }
    }
}
