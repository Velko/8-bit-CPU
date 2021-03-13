#include "serial_host.h"

/* Skip everything if building for AVR */
#ifndef __AVR__

#include <termios.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


#define BAUDRATE B115200
#define MODEMDEVICE "pty1"


void SerialHost::begin(unsigned long baud)
{
    struct termios newtio;

    fd = open(MODEMDEVICE, O_RDWR | O_NOCTTY );
    if (fd <0) {perror(MODEMDEVICE); exit(-1); }

    memset(&newtio, 0, sizeof(newtio));
    newtio.c_cflag = BAUDRATE | CRTSCTS | CS8 | CLOCAL | CREAD;
    newtio.c_iflag = IGNPAR;
    newtio.c_oflag = 0;

    /* set input mode (non-canonical, no echo,...) */
    newtio.c_lflag = 0;

    newtio.c_cc[VTIME]    = 50;   /* 5 sec timeout */
    newtio.c_cc[VMIN]     = 0;   /* unused */

    tcflush(fd, TCIFLUSH);
    tcsetattr(fd,TCSANOW,&newtio);
}

size_t SerialHost::write(uint8_t byte)
{
    return ::write(fd, &byte, 1);
}

size_t SerialHost::write(const uint8_t *buffer, size_t size)
{
    return ::write(fd, buffer, size);
}

size_t SerialHost::readBytes(uint8_t *buffer, size_t length)
{
    return ::read(fd, buffer, length);
}

int SerialHost::read()
{
    uint8_t val;
    if (::read(fd, &val, 1) > 0)
        return val;
    else
        return -1;
}

String SerialHost::readStringUntil(char terminator)
{
    std::string str;

    char c;

    while (::read(fd, &c, 1) > 0)
    {
        if (c == terminator) break;
        str += c;
    }

    return String(std::move(str));
}


void SerialHost::print(const char *str)
{
    for (; *str; ++str)
        write(*str);
}

void SerialHost::println(const char *str)
{
    print(str);
    write('\r');
    write('\n');
}

void SerialHost::println(const String &str)
{
    println(str.c_str());
}



SerialHost Serial;


#endif /* __AVR__ */