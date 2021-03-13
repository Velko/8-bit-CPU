#ifndef XMPROG_H
#define XMPROG_H

#include <stdint.h>
#include <stddef.h>


#ifdef __AVR__
#else
#include "serial_host.h"
#endif


class XmProg
{
    private:
        HardwareSerial &s_port;
    public:
        XmProg(HardwareSerial &serial);
        void StepMainLoop();
        void SendRomContents(const char *file_name);
        void ReceiveRomContents(const char *file_name);
};


#endif /* XMPROG_H */