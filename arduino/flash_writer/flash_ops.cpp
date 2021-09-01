#include <Arduino.h>
#include "flash_hw.h"

#define FLASH_SIZE   ( 128UL * 1024)   // SST39SF010

void flash_identify()
{
    flash_prepare_write();
    flash_send_command(0x5555, 0xaa);
    flash_send_command(0x2aaa, 0x55);
    flash_send_command(0x5555, 0x90);
    flash_end_write();

    delayMicroseconds(1);

    // read the ID
    uint8_t manufacturer = flash_read(0);
    uint8_t device = flash_read(1);

    char buff[8];
    sprintf_P(buff, PSTR("%02X %02X"), manufacturer, device);
    Serial.println(buff);

    flash_prepare_write();
    flash_send_command(0x00, 0xF0);
    flash_end_write();
}


void flash_read_contents()
{
    char buff[8];

    for (uint32_t addr = 0; addr < FLASH_SIZE; ++addr)
    {
        uint8_t value = flash_read(addr);

        /* Print address when starting with each 16-th byte */
        if ((addr & 0x0F) == 0)
        {
            sprintf_P(buff, PSTR("%05lX  "), addr);
            Serial.print(buff);
        }

        /* Output the byte */
        sprintf_P(buff, PSTR("%02X "), value);
        Serial.print(buff);

        /* Newline after 16 bytes */
        if ((addr & 0x0F) == 0x0F)
        {
            Serial.println();
            continue;
        }

        /* Add extra space after first 8 bytes */
        if ((addr & 0x07) == 0x07)
            Serial.print(F(" "));
    }
}
