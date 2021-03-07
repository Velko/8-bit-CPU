#ifndef SERPROG_H
#define SERPROG_H

#include <stdint.h>
#include <stddef.h>
#include "opbuf.h"


template <typename T>
class SerProg
{
    private:
        T& s_port;
        OpBuf opbuf;
        void sendInt(uint32_t value, size_t bytes);
        uint32_t readInt(size_t bytes);
    public:
        SerProg(T &serial);
        void MainLoop();

        void Ack();
        void Nak();
        void IfaceVer();
        void CmdMap();
        void BusType();
        void WrnMaxLen();
        void PrgName();
        void SerBuf();
        void InitOpbuf();
        void OpbufSize();
        void WriteOByte();
        void OExec();
        void RByte();
        void Delay();
        void RNBytes();



};


#endif /* SERPROG_H */