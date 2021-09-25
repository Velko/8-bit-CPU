#include <stdio.h>
#include <termios.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include<sys/wait.h>

#define BAUDRATE B115200

int open_port(const char* port)
{

    int fd = open(port, O_RDWR | O_NOCTTY);
    if (fd <0) {perror(port); exit(-1); }

    return fd;
}

void set_speed(int fd)
{
    struct termios newtio;

    memset(&newtio, 0, sizeof(newtio));
    newtio.c_cflag = BAUDRATE | CRTSCTS | CS8 | CLOCAL | CREAD;
    newtio.c_iflag = IGNPAR;
    newtio.c_oflag = 0;

    /* set input mode (non-canonical, no echo,...) */
    newtio.c_lflag = 0;

    newtio.c_cc[VTIME]    = 0;   /* 5 sec timeout */
    newtio.c_cc[VMIN]     = 1;   /* unused */

    tcflush(fd, TCIFLUSH);
    tcsetattr(fd,TCSANOW,&newtio);
}


void reset_arduino(int port_fd)
{
    int flags;
    if (ioctl(port_fd, TIOCMGET, &flags) < 0)
    {
        perror("read flags");
        exit(1);
    }

    flags &= ~TIOCM_DTR;
    if (ioctl(port_fd, TIOCMSET, &flags) < 0)
    {
        perror("set dtr off");
        exit(1);
    }

    sleep(1);

    flags |= TIOCM_DTR;
    if (ioctl(port_fd, TIOCMSET, &flags) < 0)
    {
        perror("set drt on");
        exit(1);
    }
}


int main()
{
    //int port_fd = open_port("/dev/ttyACM0");
    int port_fd = open_port("../pty0");

    set_speed(port_fd);
//    reset_arduino(port_fd);


    FILE *port = fdopen(port_fd, "wb+");

    if (port == NULL)
        perror("Port");

    char buffer[80];

    fprintf(stderr, "Waiting for device");
    fflush(stderr);

    do {
        fgets(buffer, 80, port);
        putc('.', stderr);
        fflush(stderr);
    }
    while (strncmp(buffer, "XMODEM", 6) != 0);
    fprintf(stderr, "\n%s", buffer);



    fprintf(port, "sx desas.bin\r\n");
    fflush(port);


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
        execl("/usr/bin/rx", "/usr/bin/rx", "-c", "mans.bin", (char*)NULL);
    }
    else
    {
        wait(NULL);
    }

    return 0;
}
