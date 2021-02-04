#ifndef CLOCK_H
#define CLOCK_H

class Clock
{
        int pin;
    public:
        Clock(int pin);
        void setup();
        void pulse();
};


#endif /* CLOCK_H */
