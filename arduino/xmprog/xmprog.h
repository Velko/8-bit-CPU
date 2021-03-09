#ifndef XMPROG_H
#define XMPROG_H

#include <stdint.h>
#include <stddef.h>

template <typename T>
class XmProg
{
    private:
        T& s_port;
    public:
        XmProg(T &serial);
        void StepMainLoop();
};


#endif /* XMPROG_H */