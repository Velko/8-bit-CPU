#ifndef BUS_ALU_H
#define BUS_ALU_H

#include <iobus.h>
#include "ext_device.h"
#include "bus_register.h"


class SecondRegister : public Register
{
    protected:
        uint8_t get_pin_load() override;
        uint8_t get_pin_out() override;
};

class ALU : public ExternalDevice
{
    public:
        ALU();
        void setup() override;
        uint8_t add(uint8_t a, uint8_t b, bool carry_in=false);
        int8_t sub(uint8_t a, uint8_t b, bool carry_in=false);
        uint8_t read_flags();
    private:
        Register reg_a;
        SecondRegister reg_b;
        IOBus flags;
};


#endif BUS_ALU_H