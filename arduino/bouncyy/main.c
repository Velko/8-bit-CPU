#define F_CPU  8000000UL

#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>

/* Decription:
 * Software de-bounce the switch and then (for testing purposes) introduce a signal
 * that always bounces.
 *
 * Wiring:
 *  PB2 - switch input (active low, pull-up enabled)
 *  PB0 - debounced output (inverse input, debounced)
 *  PB1 - re-bounced output (artifical bouncing for testing purposes, copies button)
 *
 * Note: this version is for ATtiny25, but it should work fine on Arduino as long as
 *       wiring is connected accordingly:
 *       PB0 = Arduino  8
 *       PB1 = Arduino  9
 *       PB2 = Arduino 10
 */

void setup();
void loop();

int main()
{
    setup();

    for(;;) loop();
}

// -------------------- Arduino-like sketch ------------------------------

#define DEBOUNCED_OUT     PB0
#define BOUNCY_OUT        PB1
#define BUTTON            PB2


uint8_t old_state;

void setup()
{
    DDRB = _BV(DEBOUNCED_OUT) | _BV(BOUNCY_OUT); // enable outputs
    PORTB = _BV(DEBOUNCED_OUT) | _BV(BOUNCY_OUT) | _BV(BUTTON); // outputs: high, pull-up for button

    old_state = _BV(BUTTON);  // pin high (button released)
}

void loop()
{
    //pin state changed, wait until switch settles, before measure it again
    if ((PINB & _BV(BUTTON)) != old_state) _delay_ms(50);

    if ((PINB & _BV(BUTTON)) != old_state) // still toggled?
    {
        // save for next
        old_state = PINB & _BV(BUTTON);

        uint8_t stable_port = old_state
            ? _BV(BOUNCY_OUT) | _BV(BUTTON)
            : _BV(DEBOUNCED_OUT) | _BV(BUTTON); // keep button always high, invert debounced

        uint8_t bouncy_port = stable_port ^ _BV(BOUNCY_OUT); //opposite state of bouncy_out

        // Bounce few times
        PORTB = bouncy_port;
        _delay_us(5);
        PORTB = stable_port;
        _delay_us(5);
        PORTB = bouncy_port;
        _delay_us(5);
        PORTB = stable_port;
        _delay_us(5);
        PORTB = bouncy_port;
        _delay_us(5);
        PORTB = stable_port;
    }
}
