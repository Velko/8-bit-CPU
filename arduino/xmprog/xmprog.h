#ifndef XMPROG_H
#define XMPROG_H

#include <stdint.h>
#include <stddef.h>
#include <stdio.h>


#ifdef __AVR__
#else
#include "serial_host.h"
#include <unistd.h>
#define delay(X) sleep(X/1000)

#endif


class XmProg
{
    private:
        void ReceivePacket();
    public:
        void StepMainLoop();
        void SendRomContents(const char *file_name);
        void ReceiveRomContents(const char *file_name);
};


#endif /* XMPROG_H */