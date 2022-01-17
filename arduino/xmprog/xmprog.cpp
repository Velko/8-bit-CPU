#define F_CPU 16000000UL
#include "xmprog.h"
#include "debug.h"
#include "ctimer.h"
#include <string.h>
#include <stdio.h>
#include <avr/pgmspace.h>
#include <util/delay.h>

#ifdef __AVR__
#include "uart.h"
#endif

#define SOH     0x01
#define EOT     0x04
#define ACK     0x06
#define NAK     0x15
#define ETB     0x17
#define C       0x43


int calcrc(char *ptr, int count);

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
    fgets(cmdbuf, 20, serial);

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
        fprintf_P(serial, PSTR("What?\r\n"));
    }
}

uint8_t chipmem[128];
uint8_t gendata;

void XmProg::SendRomContents(const char *file_name)
{
    dprintf("Sending file: '%s'\n", file_name);

    gendata = 0;

    /* Wait for initial C before starting to send */
    for(;;)
    {
        int init_c = fgetc(serial);
        dprintf("C: %d\n", init_c);
        if (init_c == C) break;
    }

    for (size_t p_idx = 1; p_idx <= 1024; ++p_idx)
    {
        /* Generate some data */
        for (int i = 0; i < 128; ++i)
            chipmem[i] = gendata++;
        gendata--;

        bool repeat_package = true;
        while (repeat_package) {
            fputc(SOH, serial);
            fputc(p_idx & 0xFF, serial);
            fputc((0xFF - p_idx) & 0xFF, serial);

            fwrite(chipmem, 1, 128, serial);

            uint16_t crc = calcrc((char *)chipmem, 128);

            fputc(crc >> 8, serial);
            fputc(crc & 0xFF, serial);

            for (;;)
            {
                int ack = fgetc(serial);
                if (ack == ACK || ack == NAK)
                {
                    repeat_package = ack == NAK;

                    if (repeat_package)
                        dprintf("Resend: %d\n", p_idx);
                    break;
                }
                dprintf("WTF on ack??? %x\n", ack);
            }
        }
    }

    fputc(EOT, serial);
    for (;;)
    {
        int ack = fgetc(serial);
        if (ack == ACK)
        {
            break;
        }
        dprintf("WTF on close??? %x\n", ack);
    }

    dprintf("Here we go!\n");
}

void XmProg::ReceivePacket()
{
    uint16_t packed_id;
    fread(&packed_id, 1, 2, serial);
    fread(chipmem, 1, 128, serial);
    uint16_t crc_recv;
    fread(&crc_recv, 1, 2, serial);

    /* swap bytes */
    crc_recv = (crc_recv << 8) | (crc_recv >> 8);

    uint16_t crc_calc = calcrc((char *)chipmem, 128);

    if (crc_calc == crc_recv)
    {
        dprintf("block %x received\n", packed_id);
        fputc(ACK, serial);
    }
    else
    {
        dprintf("block %x failed %x != %x\n", packed_id, crc_recv, crc_calc);
        fputc(NAK, serial);
    }
}

void XmProg::ReceiveRomContents(const char *file_name)
{
    dprintf("Waiting for file: '%s'\n", file_name);

    /* give some time for sender to start, then send initial "C" indicating
       that we're ready to receive using XMODEM-CRC protocol
     */
    _delay_ms(1000);
    fputc(C, serial);

    /* enable "ctimer" - keeps sending "C" in background, in case first one
       was missed by sender */
    ctimer_start();

    for (;;) {

        /* wait for the beginning of the frame */
        int soh = -1;
        while (soh == -1) soh = fgetc(serial);

        /* got something from sender, stop the background timer */
        ctimer_stop();

        switch (soh)
        {
        case SOH:
            ReceivePacket();
            break;
        case EOT:
            fputc(ACK, serial);
            return;
        default:
            dprintf("WTF??? %x\n", soh);
            return;
        }
    }
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
