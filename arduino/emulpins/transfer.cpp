#include "devices.h"
#include "op-defs.h"

TransferReg  TR(MPIN_TX_OUT_BITS, MPIN_TX_LOAD_BITS,
                MPIN_TL_OUT_BITS, MPIN_TL_LOAD_BITS,
                MPIN_TH_OUT_BITS, MPIN_TH_LOAD_BITS,
                HPIN_TL_ADD_BIT);

TransferReg::TransferReg(cword_t out_x, cword_t load_x,
                         cword_t out_l, cword_t load_l,
                         cword_t out_h, cword_t load_h,
                         cword_t add)
    : _out_x(MUX_ADDROUT_MASK, out_x),
      _load_x(MUX_ADDRLOAD_MASK, load_x),
      _out_l(MUX_OUT_MASK, out_l),
      _load_l(MUX_LOAD_MASK, load_l),
      _out_h(MUX_OUT_MASK, out_h),
      _load_h(MUX_LOAD_MASK, load_h),
      _add(add, add)
{}

void TransferReg::control_updated()
{
    if (_out_x.is_enabled(_control))
        address_bus = val;

    if (_out_l.is_enabled(_control))
        main_bus = val & 0xFF;

    if (_out_h.is_enabled(_control))
        main_bus = val >> 8;
}

void TransferReg::clock_pulse()
{
    if (_load_x.is_enabled(_control))
        val = address_bus;

    if (_load_h.is_enabled(_control))
        val = (val & 0xFF ) | (main_bus << 8);

    if (_load_l.is_enabled(_control))
        val = (val & 0xFF00 ) | main_bus;

    if (_add.is_enabled(_control)) {
        int8_t offset = main_bus;
        val += (int16_t)offset;
    }

}