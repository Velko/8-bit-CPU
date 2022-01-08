#define F_CPU 16000000UL
#include "xmprog.h"
#include "debug.h"
#include <string.h>
#include <stdio.h>
#include <avr/pgmspace.h>
#include <util/delay.h>

#define SOH     0x01
#define EOT     0x04
#define ACK     0x06
#define NAK     0x15
#define ETB     0x17
#define C       0x43


int calcrc(char *ptr, int count);

XmProg::XmProg(FILE *s)
{
    s_port =  s;
}

char cmdbuf[20];

void trim_end(char *str)
{
    char *s = str;
    for (; *s; ++s);

    while (s > str && (*s == '\r' || *s == ' ')) --s;
    *s = 0;
}

void XmProg::StepMainLoop()
{
    fgets(cmdbuf, 20, s_port);

    trim_end(cmdbuf);

    if (cmdbuf[0] == 0) return;

    if (strncmp_P(cmdbuf, PSTR("sx "), 3) == 0)
    {
        SendRomContents(cmdbuf + 3);
    }
    if (strncmp_P(cmdbuf, PSTR("rx "), 3) == 0)
    {
        ReceiveRomContents(cmdbuf + 3);
    }
    else
    {
        fprintf_P(s_port, PSTR("What?\r\n"));
    }
}

uint8_t chipmem[128];

void XmProg::SendRomContents(const char *file_name)
{
    dprintf("Sending file: '%s'\n", file_name);

    memset(chipmem, 0xFF, 128);


    /* Wait for initial C before starting to send */
    for(;;)
    {
        int init_c = fgetc(s_port);
        dprintf("C: %d\n", init_c);
        if (init_c == C) break;
    }

    for (size_t data = 1; data <= 1024; ++data)
    {
        bool repeat_package = true;
        while (repeat_package) {
            fputc(SOH, s_port);
            fputc(data & 0xFF, s_port);
            fputc((0xFF - data) & 0xFF, s_port);

            fwrite(chipmem, 1, 128, s_port);

            uint16_t crc = calcrc((char *)chipmem, 128);

            fputc(crc >> 8, s_port);
            fputc(crc & 0xFF, s_port);

            for (;;)
            {
                int ack = fgetc(s_port);
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

    fputc(EOT, s_port);
    for (;;)
    {
        int ack = fgetc(s_port);
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

    int soh = 0;
    for (unsigned i = 0; i < 3 && soh != SOH; ++i)
    {
        /* wait and send initial Cs until sender starts */
        _delay_ms(1000);
        fputc(C, s_port);

        soh = fgetc(s_port);

    }

    if (soh != SOH) return;


    for (;;) {

        uint16_t packed_id;
        fread(&packed_id, 1, 2, s_port);
        uint8_t data[128];
        fread(data, 1, 128, s_port);
        uint16_t crc_recv;
        fread(&crc_recv, 1, 2, s_port);

        /* swap bytes */
        crc_recv = (crc_recv << 8) | (crc_recv >> 8);

        uint16_t crc_calc = calcrc((char *)data, 128);

        if (crc_calc == crc_recv)
        {
            dprintf("block %x received\n", packed_id);
            fputc(ACK, s_port);
        }
        else
        {
            dprintf("block %x failed %x != %x\n", packed_id, crc_recv, crc_calc);
            fputc(NAK, s_port);
        }

        int soh = -1;
        while (soh == -1) {
            soh = fgetc(s_port);
        }

        if (soh == SOH) continue;
        if (soh == EOT)
        {
           fputc(ACK, s_port);
            return;
        }

        dprintf("WTF??? %x\n", soh);
        return;
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
