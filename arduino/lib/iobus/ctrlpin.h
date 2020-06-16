#ifndef CTRL_PIN_H
#define CTRL_PIN_H

#include <stdint.h>

class CtrlPin {
    public:
        enum ActiveLevel {
            ACTIVE_HIGH,
            ACTIVE_LOW,
        };
        CtrlPin(uint8_t pin, ActiveLevel mode);
        void setup();
        void on();
        void off();
        void set(bool enabled);
    private:
        uint8_t pin;
        ActiveLevel mode;
};


#endif  /* CTRL_PIN_H */