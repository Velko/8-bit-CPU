#include "pexec.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include<sys/wait.h>


void pexec(int port_fd, char *const argv[])
{
    int pid = fork();
    if (pid < 0)
    {
        perror("fork");
        exit(1);
    }
    if (pid == 0)
    {
        dup2(port_fd, 1);
        dup2(port_fd, 0);
        execv(argv[0], argv);
    }
    else
    {
        wait(NULL);
    }
}