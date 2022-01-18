#ifndef CTRLPINS_H
#define CTRLPINS_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

    void ctrl_pins_setup();
    void ctrl_oe_on();
    void ctrl_oe_off();
    void ctrl_we_pulse();
    void ctrl_chip_select(uint8_t chip);

#ifdef __cplusplus
}
#endif

#endif /* CTRLPINS_H */

