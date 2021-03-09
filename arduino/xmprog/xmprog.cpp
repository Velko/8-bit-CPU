#include "xmprog.h"

#include <stdio.h>

/* Instantiate SerProg for hosted */
#include "serial_host.h"
template class XmProg<SerialHost>;

template <typename T>
XmProg<T>::XmProg(T &s)
    : s_port{s}
{
}

template <typename T>
void XmProg<T>::StepMainLoop()
{
    String cmd = s_port.readStringUntil('\r');

    if (cmd.startsWith("sx "))
    {
        s_port.println("Get ready to receive");
    }
    else if (cmd.startsWith("rx "))
    {
        s_port.println("Send now");
    }
    else
    {
        s_port.println("What?");
    }
}