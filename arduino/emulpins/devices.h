#ifndef DEVICES_H
#define DEVICES_H

#include <stdint.h>
#include "microcode.h"

extern uint8_t main_bus;
extern uint16_t address_bus;
extern uint8_t flags_bus;
extern uint8_t alu_arg_l_bus;
extern uint8_t alu_arg_r_bus;

void set_control(uint32_t control_word);
void clock_pulse();
void clock_inverted();

class CpuDevice {
    protected:
        cword_t _control;
        virtual void control_updated();
    public:
        void apply_control(cword_t control);
        virtual void clock_pulse();
        virtual void clock_inverted();
};

class ControlSignal {
        cword_t _mask;
        cword_t _bits;
    public:
        ControlSignal(cword_t mask, cword_t bits);
        ControlSignal(bool on);
        bool is_enabled(cword_t control);
};

class Register : public CpuDevice {
    private:
        uint8_t latched_primary;
        uint8_t latched_secondary;
        ControlSignal _out;
        ControlSignal _load;
        ControlSignal _tap_l;
        ControlSignal _tap_r;
    protected:
        void control_updated() override;
    public:
        Register(cword_t out, cword_t load, cword_t tap_l, cword_t tap_r);
        uint8_t read_tap();
        void clock_pulse() override;
        void clock_inverted() override;
};

class InstructionRegister : public CpuDevice {
    private:
        uint8_t latched_primary;
        uint8_t latched_secondary;
        ControlSignal _load;
    public:
        InstructionRegister(cword_t load);
        uint8_t read_tap();
        void clock_pulse() override;
        void clock_inverted() override;
};

class ALU_Unit : public CpuDevice {
    protected:
        ControlSignal _out;
        ControlSignal _alt;
        ControlSignal _carry;
    public:
        ALU_Unit(cword_t out, cword_t alt, cword_t carry);
};

class ALU_AddSub : public ALU_Unit {
    protected:
        void control_updated() override;
    public:
        ALU_AddSub(cword_t out, cword_t alt, cword_t carry);
};

class ALU_AndOr {
    private:
        bool op_or;
    public:
        ALU_AndOr();
        void set_or(bool logical_or);
        void set_out(bool enabled);
};

class ALU_ShiftSwap {
    private:
        bool op_swap;
        bool carry;
    public:
        ALU_ShiftSwap();
        void set_swap(bool swap);
        void set_carry(bool carry);
        void set_out(bool enabled);
};

class ALU_XorNot {
    private:
        bool op_not;
    public:
        ALU_XorNot();
        void set_not(bool logical_not);
        void set_out(bool enabled);
};


#define FLAG_V  0b1000
#define FLAG_C  0b0100
#define FLAG_Z  0b0010
#define FLAG_N  0b0001


class FlagsReg : public CpuDevice
{
    private:
        uint8_t latched_primary;
        uint8_t latched_secondary;
        ControlSignal _out;
        ControlSignal _load;
        ControlSignal _calc;
    protected:
        void control_updated() override;
    public:
        FlagsReg(cword_t out, cword_t load, cword_t calc);
        void clock_pulse() override;
        void clock_inverted() override;
        uint8_t read_tap();
};

class ProgramCounter : public CpuDevice
{
    private:
        uint16_t primary;
        uint16_t secondary;
        ControlSignal _out_cnt;
        ControlSignal _load;
    protected:
        void control_updated() override;
    public:
        ProgramCounter(cword_t out_cnt, cword_t load);
        void clock_pulse() override;
        void clock_inverted() override;
};

class StackPointer : public CpuDevice
{
    private:
        uint16_t val;
        ControlSignal _out;
        ControlSignal _load;
        ControlSignal _inc;
        ControlSignal _dec;
    protected:
        void control_updated() override;
    public:
        StackPointer(cword_t out, cword_t load, cword_t inc, cword_t dec);
        void clock_pulse() override;
};

class Memory : public CpuDevice
{
    private:
        ControlSignal _out;
        ControlSignal _write;
    protected:
        void control_updated() override;
    public:
        Memory(cword_t out, cword_t write);
        void setup();
        void clock_pulse() override;
};

class AddressReg
{
    private:
        uint16_t val;
        bool load_enabled;
    public:
        void set_out(bool enabled);
        void set_load(bool enabled);
        void clock_pulse();
};

class TransferReg : public CpuDevice
{
    private:
        uint16_t val;
        ControlSignal _out_x;
        ControlSignal _load_x;
        ControlSignal _out_l;
        ControlSignal _load_l;
        ControlSignal _out_h;
        ControlSignal _load_h;
        ControlSignal _add;
    protected:
        void control_updated() override;
    public:
        TransferReg(cword_t out_x, cword_t load_x,
                  cword_t out_l, cword_t load_l,
                  cword_t out_h, cword_t load_h,
                  cword_t add);
        void clock_pulse() override;
};


extern Register A;
extern Register B;
extern InstructionRegister IR;
extern ALU_AddSub AddSub;
extern ALU_AndOr AndOr;
extern ALU_ShiftSwap ShiftSwap;
extern ALU_XorNot XorNot;
extern FlagsReg Flags;
extern ProgramCounter PC;
extern StackPointer r_SP;
extern ProgramCounter LR;
extern Memory RAM;
extern AddressReg   DP;
extern TransferReg  TR;

#endif  /* DEVICES_H */
