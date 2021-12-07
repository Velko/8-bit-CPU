#ifndef CPU_H
#define CPU_H

#include "Vcpu.h"

class CPU : public Vcpu
{
    bool send_main_bus;
    bool send_addr_bus;
public:
    void off();
    void reset();
    void clk_pulse();
    void iclk_pulse();
    void clock_tick();

    void set_control_word(uint32_t word);
    void main_bus_write(uint8_t data);
    void main_bus_set_input();
    void addr_bus_write(uint16_t addr);
    void addr_bus_set_input();

};


#endif /* CPU_H */
