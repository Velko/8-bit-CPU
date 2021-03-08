#include "serprog.h"
#include "serprog-proto.h"
#include "debug.h"

#include <string.h>

#ifndef __AVR__

/* Instantiate SerProg for hosted */
#include "serial_host.h"
template class SerProg<SerialHost>;

#define PSTR(X) (X)
#define strcpy_P strcpy

#else

/* Instantiate SerProg for Arduino */
#include <HardwareSerial.h>
template class SerProg<HardwareSerial>;

#endif

#define CHIPSIZE    128 * 1024UL
#define ADDR_OFFSET  (0x1000000UL - CHIPSIZE)

template <typename T>
SerProg<T>::SerProg(T &s)
    : s_port{s}
{
}

template <typename T>
void SerProg<T>::Ack()
{
    s_port.write(S_ACK);
}

template <typename T>
void SerProg<T>::Nak()
{
    s_port.write(S_NAK);
}

template <typename T>
void SerProg<T>::sendInt(uint32_t value, size_t bytes)
{
    s_port.write((uint8_t *)&value, bytes);
}

template <typename T>
uint32_t SerProg<T>::readInt(size_t bytes)
{
    uint32_t result = 0;
    s_port.readBytes((uint8_t *)&result, bytes);
    return result;
}

template <typename T>
void SerProg<T>::IfaceVer()
{
    dprintf("Q_IFACE\n");
    Ack();
    sendInt(1, 2);
}

template <typename T>
void SerProg<T>::CmdMap()
{
    dprintf("Q_CMDMAP\n");
    Ack();
    /* Support first 16 commands */
    s_port.write(0xFF);
    s_port.write(0xFF);

    /* Everything else unsupported */
    for (int i = 2; i < 32; ++i)
    {
        s_port.write(0);
    }
}

template <typename T>
void SerProg<T>::BusType()
{
    dprintf("Q_BUSTYPE\n");
    Ack();
    s_port.write(0x01); // Parallel only
}

template <typename T>
void SerProg<T>::WrnMaxLen()
{
    dprintf("Q_WRNMAXLEN\n");
    Ack();
    sendInt(64, 3);
}

template <typename T>
void SerProg<T>::PrgName()
{
    dprintf("Q_PRGNAME\n");
    Ack();
    char buffer[16];
    memset(buffer, 0, sizeof(buffer));
    strcpy_P(buffer, PSTR("BEBRS"));
    s_port.write((uint8_t *)buffer, sizeof(buffer));
}

template <typename T>
void SerProg<T>::SerBuf()
{
    dprintf("Q_SERBSIZE\n");
    Ack();
    sendInt(16, 2);
}

template <typename T>
void SerProg<T>::InitOpbuf()
{
    dprintf("INIT_OB\n");
    opbuf.init();
    Ack();
}

template <typename T>
void SerProg<T>::OpbufSize()
{
    dprintf("Q_OB_SIZE\n");
    Ack();
    sendInt(opbuf.size(), 2);
}

template <typename T>
void SerProg<T>::WriteOByte()
{
    *opbuf.write_into(1) = S_CMD_O_WRITEB;

    s_port.readBytes(opbuf.write_into(4), 4);

    uint32_t *p = (uint32_t *)opbuf.write_into(0);
    uint32_t addr= (p[-1] & 0x00FFFFFF) - ADDR_OFFSET;
    dprintf("WRITE_BYTE %06x %02x\n", addr, p[-1] >> 24);

    Ack();
}

template <typename T>
void SerProg<T>::WriteNBytes()
{
    *opbuf.write_into(1) = S_CMD_O_WRITEN;

    uint8_t *b = opbuf.write_into(6);
    s_port.readBytes(b, 6);

    uint32_t *p = (uint32_t *)b;
    uint32_t len = *p & 0x00FFFFFF;
    dprintf("WRITEN_BYTES %06x\n", len);

    s_port.readBytes(opbuf.write_into(len), len);

    Ack();
}


template <typename T>
void SerProg<T>::OExec()
{
    dprintf("OEXEC\n");
    Ack();
    opbuf.exec();
}

extern uint8_t *active_mem;

template <typename T>
void SerProg<T>::RByte()
{
    uint32_t addr = readInt(3);
    Ack();

    addr -= ADDR_OFFSET;

    dprintf("RBYTE_%x\n", addr);

    s_port.write(active_mem[addr]);
}

template <typename T>
void SerProg<T>::Delay()
{
    dprintf("DELAY\n");
    uint32_t delay = readInt(4);
    Ack();
}

template <typename T>
void SerProg<T>::RNBytes()
{
    uint32_t addr = readInt(3);
    uint32_t len = readInt(3);

    addr -= ADDR_OFFSET;

    dprintf("RNBYTES_%x %x\n", addr, len);

    Ack();

    s_port.write(active_mem + addr, len);
}

template <typename T>
void SerProg<T>::MainLoop()
{
    int b = s_port.read();
    switch (b)
    {
        case -1:
            // not a command, just serial timeout
            break;
        case S_CMD_NOP:
            dprintf("NOP\n");
            Ack();
            break;
        case S_CMD_SYNCNOP:
            dprintf("SNOP\n");
            Nak();
            Ack();
            break;
        case S_CMD_Q_IFACE:
            IfaceVer();
            break;
        case S_CMD_Q_CMDMAP:
            CmdMap();
            break;
        case S_CMD_Q_BUSTYPE:
            BusType();
            break;
        case S_CMD_Q_WRNMAXLEN:
            WrnMaxLen();
            break;
        case S_CMD_Q_PGMNAME:
            PrgName();
            break;
        case S_CMD_Q_SERBUF:
            SerBuf();
            break;
        case S_CMD_O_INIT:
            InitOpbuf();
            break;
        case S_CMD_Q_OPBUF:
            OpbufSize();
            break;
        case S_CMD_O_WRITEB:
            WriteOByte();
            break;
        case S_CMD_O_EXEC:
            OExec();
            break;
        case S_CMD_R_BYTE:
            RByte();
            break;
        case S_CMD_O_DELAY:
            Delay();
            break;
        case S_CMD_R_NBYTES:
            RNBytes();
            break;
        case S_CMD_O_WRITEN:
            WriteNBytes();
            break;
        default:
            dprintf("Unimplemented cmd %x\n", b);
            Nak();
            break;
    }
}