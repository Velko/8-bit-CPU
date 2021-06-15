#include <SPI.h>
#include "devices.h"

Memory RAM;

#define RAM_CS  SS

#define RAM_MODE_BYTE   0

#define WRMR_CMD    0x01
#define WRITE_CMD   0x02
#define READ_CMD    0x03

void Memory::setup()
{
    // init SPI
    SPI.begin();
    SPI.setDataMode(SPI_MODE0);
    SPI.setBitOrder(MSBFIRST);
    SPI.setClockDivider(SPI_CLOCK_DIV2);

    // setup CS
    digitalWrite(RAM_CS, HIGH);
    pinMode(RAM_CS, OUTPUT);

    // set byte mode
    digitalWrite(RAM_CS, LOW);
    SPI.transfer(WRMR_CMD);
    SPI.transfer(RAM_MODE_BYTE);
    digitalWrite(RAM_CS, HIGH);
}

void Memory::set_out(bool enabled)
{
    if (enabled)
    {
        digitalWrite(RAM_CS, LOW);
        SPI.transfer(READ_CMD);
        uint16_t addr = address_bus;
        SPI.transfer(addr >> 8);        // address MSB
        SPI.transfer(addr & 0xFF);      // address LSB
        main_bus = SPI.transfer(0xFF);
        digitalWrite(RAM_CS, HIGH);
    }
}

void Memory::set_write(bool enabled)
{
    write_enabled = enabled;
}

void Memory::clock_pulse()
{
    if (write_enabled)
    {
        digitalWrite(RAM_CS, LOW);
        SPI.transfer(WRITE_CMD);
        uint16_t addr = address_bus;
        SPI.transfer(addr >> 8);        // address MSB
        SPI.transfer(addr & 0xFF);      // address LSB
        SPI.transfer(main_bus);
        digitalWrite(RAM_CS, HIGH);
    }
}
