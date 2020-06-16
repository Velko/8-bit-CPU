#ifndef BUS_ALU_H
#define BUS_ALU_H

#include <iobus.h>
#include "ext_device.h"
#include "bus_register.h"


class SecondRegister : public Register
{
    public:
        SecondRegister();
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
        CtrlPin pin_out;
        CtrlPin pin_subtract;
        CtrlPin pin_use_carry;
};


#endif BUS_ALU_H