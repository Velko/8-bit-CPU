#ifndef DEVICES_H
#define DEVICES_H

#include <stdint.h>

extern uint8_t main_bus;
extern uint8_t flags_bus;

void set_control(uint16_t control_word);
void clock_pulse();
void clock_inverted();

class Register {
    private:
        uint8_t latched_primary;
        uint8_t latched_secondary;
        bool load_enabled;
        bool out_enabled;
        bool tap_a_enabled;
        bool tap_b_enabled;
    public:
        Register();
        void set_load(bool enabled);
        void set_out(bool enabled);
        uint8_t read_tap_a();
        uint8_t read_tap_b();
        void clock_pulse();
        void clock_inverted();
};


class ALU_AddSub {
    private:
        bool sub;
        bool carry;
    public:
        ALU_AddSub();
        void set_sub(bool subtract);
        void set_carry(bool carry);
        void set_out(bool enabled);
};

#define FLAG_V  0b1000
#define FLAG_C  0b0100
#define FLAG_Z  0b0010
#define FLAG_N  0b0001


class FlagsReg
{
    private:
        uint8_t latched_primary;
        uint8_t latched_secondary;
        bool load_enabled;
        bool load_raw;
    public:
        FlagsReg();
        void set_out(bool enabled);
        void set_load(bool enabled);
        void set_sel(bool loadraw);
        void clock_pulse();
        void clock_inverted();
        uint8_t read_tap();
};

class ProgramCounter
{
    private:
        uint8_t val;
        bool count_enabled;
        bool load_enabled;
    public:
        void set_out(bool enabled);
        void set_load(bool enabled);
        void set_count(bool enabled);
        void clock_pulse();
};

class Memory
{
    private:
        uint8_t data[256];
        bool write_enabled;
    public:
        void set_out(bool enabled);
        void set_write(bool enabled);
        void clock_pulse();
};

extern Register A;
extern Register B;
extern Register IR;
extern Register MAR;
extern ALU_AddSub AddSub;
extern FlagsReg Flags;
extern ProgramCounter PC;
extern Memory RAM;

#endif  /* DEVICES_H */