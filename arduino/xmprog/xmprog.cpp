#include "xmprog.h"
#include "debug.h"
#include <string.h>

#define SOH     0x01
#define EOT     0x04
#define ACK     0x06
#define NAK     0x15
#define ETB     0x17
#define C       0x43


int calcrc(char *ptr, int count);

XmProg::XmProg(HardwareSerial &s)
    : s_port{s}
{
}

void XmProg::StepMainLoop()
{
    String cmd = s_port.readStringUntil('\n');

    cmd.trim();

    if (cmd.equals("")) return;

    if (cmd.startsWith("sx "))
    {
        String file_name = cmd.substring(3);
        SendRomContents(file_name.c_str());
    }
    else if (cmd.startsWith("rx "))
    {
        String file_name = cmd.substring(3);
        ReceiveRomContents(file_name.c_str());
    }
    else
    {
        s_port.println("What?");
    }
}

uint8_t chipmem[128];

void XmProg::SendRomContents(const char *file_name)
{
    dprintf("Sending file: '%s'\n", file_name);
    Serial.print("Sending file: ");
    Serial.println(file_name);

    memset(chipmem, 0xFF, 128);


    /* Wait for initial C before starting to send */
    for(;;)
    {
        int init_c = s_port.read();
        dprintf("C: %d\n", init_c);
        if (init_c == C) break;
    }

    for (size_t data = 1; data <= 1024; ++data)
    {
        bool repeat_package = true;
        while (repeat_package) {
            s_port.write(SOH);
            s_port.write(data & 0xFF);
            s_port.write((0xFF - data) & 0xFF);

            s_port.write(chipmem, 128);

            uint16_t crc = calcrc((char *)chipmem, 128);

            s_port.write(crc >> 8);
            s_port.write(crc & 0xFF);

            for (;;)
            {
                int ack = s_port.read();
                if (ack == ACK || ack == NAK)
                {
                    repeat_package = ack == NAK;

                    if (repeat_package)
                        dprintf("Resend: %d\n", data);
                    break;
                }
                dprintf("WTF on ack??? %x\n", ack);
            }
        }
    }

    s_port.write(EOT);
    for (;;)
    {
        int ack = s_port.read();
        if (ack == ACK)
        {
            break;
        }
        dprintf("WTF on close??? %x\n", ack);
    }

    dprintf("Here we go!\n");
}

void XmProg::ReceiveRomContents(const char *file_name)
{
    dprintf("Waiting for file: '%s'\n", file_name);

    for (;;)
    {
        /* wait and send initial Cs until sender starts */
        s_port.write(C);

        int soh = s_port.read();
        if (soh == SOH) break;
    }

    for (;;) {

        uint16_t packed_id;
        s_port.readBytes((uint8_t *)&packed_id, 2);
        uint8_t data[128];
        s_port.readBytes(data, 128);
        uint16_t crc_recv;
        s_port.readBytes((uint8_t *)&crc_recv, 2);

        /* swap bytes */
        crc_recv = (crc_recv << 8) | (crc_recv >> 8);

        uint16_t crc_calc = calcrc((char *)data, 128);

        if (crc_calc == crc_recv)
        {
            dprintf("block %x received\n", packed_id);
            s_port.write(ACK);
        }
        else
        {
            dprintf("block %x failed %x != %x\n", packed_id, crc_recv, crc_calc);
            s_port.write(NAK);
        }

        int soh = s_port.read();
        if (soh == SOH) continue;
        if (soh == EOT)
        {
            s_port.write(ACK);
            break;
        }

        dprintf("WTF??? %x\n", soh);

    }

    /*for (;;)
    {
        int soh = s_port.read();
        if (soh == ETB)
        {
            s_port.write(ACK);
            break;
        }
        dprintf("WTF on close??? %x\n", soh);
    } */

    dprintf("Omg Omg!\n");
}


int calcrc(char *ptr, int count)
{
    int  crc;
    char i;

    crc = 0;
    while (--count >= 0)
    {
        crc = crc ^ (int) *ptr++ << 8;
        i = 8;
        do
        {
            if (crc & 0x8000)
                crc = crc << 1 ^ 0x1021;
            else
                crc = crc << 1;
        } while(--i);
    }
    return (crc);
}