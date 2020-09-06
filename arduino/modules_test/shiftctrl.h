#ifndef SHIFT_CTRL_H
#define SHIFT_CTRL_H

#include <ctrlpin.h>

class ShiftCtrl;

class ShiftPin {
    public:
        void setup();
        void on(bool autocommit=true);
        void off(bool autocommit=true);
        void set(bool enabled, bool autocommit=true);
    private:
        ShiftPin();
        ShiftCtrl *owner;
        uint8_t pin;
        CtrlPin::ActiveLevel mode;
        friend class ShiftCtrl;
};

class ShiftCtrl
{
    public:
        ShiftCtrl();
        void setup();
        void commit();
        ShiftPin &claim(uint8_t pin, CtrlPin::ActiveLevel mode);
    private:
        uint8_t buffer;
        ShiftPin pins[8];
        friend class ShiftPin;
};

#endif /* SHIFT_CTRL_H */