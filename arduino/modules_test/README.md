Modules tester
==============

Arduino based modules tester - used to verify that modules operates as they are supposed to.
Module should be connected to Arduino and testing scenario should be launched. There's a Python
based _client.py_ script, that should be used to initiate the test.


Register
========

Checking if register latches in, holds and is able to supply back a byte value.

Wiring
------

Bus:   Arduino (9, 8, 7, 6, 5, 4, 3, 2) <-> 74HC245 (11, 12, 13, 14, 15, 16, 17, 18)
Out:   74HC594 1                         -> 74HC245 19
Load:  74HC594 15                        -> 74HC173 9 or 10
Clock: Arduino SCL                       -> 74HC173 7
Reset:                                   -> 74HC173 15  (active high)


Counter (simple 74HC163 based)
==============================

In addition for behaving as a simple, latching register it has additional feature: ability to
increase its value.


Wiring
------

Bus:   Arduino (9, 8, 7, 6, 5, 4, 3, 2) <-> 74HC245 (9, 8, 7, 6, 5, 4, 3, 2)
Out:   74HC594 1                         -> 74HC245 19
Load:  74HC594 15                        -> 74HC163 9
Clock: Arduino SCL                       -> 74HC163 2
Reset:                                   -> 74HC163 1 (active low, requires clock pulse)
Count: 74HC594 2                         -> 74HC163 7



Counter (advanced 74HC191 based)
================================

In addition for behaving as a simple, latching register it has additional features: ability to
increase and decrease its value.

Wiring
------

Bus:     Arduino (9, 8, 7, 6, 5, 4, 3, 2) <-> 74HC245 (11, 12, 13, 14, 15, 16, 17, 18)
Out:     74HC594 1                         -> 74HC245 19
Load:    74HC594 15                        -> 74HC02  3
Clock:   Arduino SCL                       -> 74HC191 14
Reset:                                     -> 74HC02  5 (active high)
Up/Down: 74HC594 3                         -> 74HC191 5
Count:   74HC594 2                         -> 74HC191 4

Display
=======

Wiring
------

Bus:     Arduino (9, 8, 7, 6, 5, 4, 2, 3) -> AT28C64 (8, 7, 6, 5, 4, 3, 25, 24)
Mode:    Arduino (13, 12)                 -> AT28C64 (23, 21)



ALU
===

Since ALU by itself requires lots of wiring, it should be tested together with Register A and
Register B.

Wiring
------

### Register A
Bus:   Arduino (9, 8, 7, 6, 5, 4, 3, 2) <-> 74HC245 (11, 12, 13, 14, 15, 16, 17, 18)
Out:   74HC594 1                         -> 74HC245 19
Load:  74HC594 15                        -> 74HC173 9 or 10
Clock: Arduino SCL                       -> 74HC173 7

### Register B
Out:   74HC594 6                        -> 74HC245 19
Load:  74HC594 2                        -> 74HC173 9 or 10
                                           74HC163 9

### ALU
Out:   74HC594 3                       -> 74HC245 19
Sub:   74HC594 4                       -> 74HC86  10
Carry: 74HC594 5                       -> 74HC00  12
FlgIn: 74HC594 3*                      -> 74HC173 9 or 10
Flags: Arduino (A3, A2, A1, A0)        -> 74HC173 (3, 4, 5, 6)

Note: ALU_OUT and FLAG_IN should be connected together while testing ADC / SBC, can be
hardwired to LOW otherwise

Shift extender
==============

Wiring
------

Latch:  Arduino 10                      -> 74HC594 12
MOSI:   Arduino 11                      -> 74HC594 14
MISO:   Arduino 12                      -> GND
SCK:    Arduino 13                      -> 74HC594 11
