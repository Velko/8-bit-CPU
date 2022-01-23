#ifndef OUT_PIN_H
#define OUT_PIN_H

#include <stdint.h>
#include <Arduino.h>

struct OutPinModeActiveHigh {
    static const int ON = HIGH;
    static const int OFF = LOW;
};

struct OutPinModeActiveLow {
    static const int ON = LOW;
    static const int OFF = HIGH;
};



template <typename LEVEL>
class OutPin {
    public:
        OutPin(uint8_t pin);
        void setup();
        void on();
        void off();
        void set(bool enabled);
    private:
        uint8_t pin;
};

typedef OutPin<OutPinModeActiveHigh> OutPinH;
typedef OutPin<OutPinModeActiveLow> OutPinL;


#endif  /* OUT_PIN_H */