#include "device_interface.h"

#include "devices.h"

void MainBus::write(uint8_t val)
{
    main_bus = val;
}

void MainBus::set_input()
{
}

uint8_t MainBus::read()
{
    return main_bus;
}

uint8_t FlagsBus::read()
{
    return Flags.read_tap();
}


void AddressBus::write(uint16_t val)
{
    address_bus = val;
}

void AddressBus::set_input()
{
}

uint16_t AddressBus::read()
{
    return address_bus;
}