#include "devices.h"
#include "op-defs.h"

Memory::Memory(cword_t out, cword_t write)
    : _out(MUX_OUT_MASK, out),
      _write(MUX_LOAD_MASK, write)
{}

#ifdef __AVR__

#include <SPI.h>

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

void Memory::control_updated()
{
    if (_out.is_enabled(_control))
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

void Memory::clock_pulse()
{
    if (_write.is_enabled(_control))
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

#else

uint8_t memory_array[0x10000]; // 64 KiB - emulated memory chip

void Memory::setup()
{
}

void Memory::control_updated()
{
    if (_out.is_enabled(_control))
    {
        uint16_t addr = address_bus;
        main_bus = memory_array[addr];
    }
}

void Memory::clock_pulse()
{
    if (_write.is_enabled(_control))
    {
        uint16_t addr = address_bus;
        memory_array[addr] = main_bus;
    }
}

#endif