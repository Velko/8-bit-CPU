#ifndef BUS_ALU_H
#define BUS_ALU_H

#include <iobus.h>
#include "ext_device.h"
#include "bus_register.h"


class SecondRegister : public Register
{
    public:
        SecondRegister(DeviceInterface &devices);
};

class ALU : public ExternalDevice
{
    public:
        ALU(DeviceInterface &devices);
        void setup() override;
        uint8_t add(uint8_t a, uint8_t b, bool carry_in=false);
        uint8_t add_b(uint8_t a, uint8_t b, bool carry_in=false);
        int8_t sub(uint8_t a, uint8_t b, bool carry_in=false);
        int8_t sub_b(uint8_t a, uint8_t b, bool carry_in=false);
        uint8_t read_flags();
        void set_carry();
        Register reg_a;
        SecondRegister reg_b;
    private:
        DeviceInterface &devices;
        ShiftPin pin_out;
        ShiftPin pin_subtract;
        ShiftPin pin_use_carry;
        ShiftPin pin_flags_load;
        ShiftPin pin_flags_out;
        ShiftPin pin_flags_sel;
};


#endif /* BUS_ALU_H */
