#ifndef CMD_H
#define CMD_H

enum pgm_action {
    ACT_NONE,
    ACT_LIST,
    ACT_READ,
    ACT_WRITE,
    ACT_VERIFY,
    ACT_ERASE,
};

struct cmd_options
{
    char *port;
    char *chip;
    enum pgm_action action;
    char *file;
};


void parse_cmd(int argc, char **argv, struct cmd_options *cmd);

#endif /* CMD_H */