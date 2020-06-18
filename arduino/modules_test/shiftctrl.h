#ifndef SHIFT_CTRL_H
#define SHIFT_CTRL_H

#include <ctrlpin.h>

class ShiftCtrl
{
    public:
        static void setup();
        static void commit();
    private:
        static uint8_t buffer;
        friend class ShiftPin;
};

class ShiftPin {
    public:
        ShiftPin(uint8_t pin, CtrlPin::ActiveLevel mode);
        void setup();
        void on(bool autocommit=true);
        void off(bool autocommit=true);
        void set(bool enabled, bool autocommit=true);
    private:
        uint8_t pin;
        CtrlPin::ActiveLevel mode;
};


#endif /* SHIFT_CTRL_H */