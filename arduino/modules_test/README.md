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
Out:   Arduino 12                        -> 74HC245 19
Load:  Arduino 13                        -> 74HC173 9 or 10
Clock: Arduino 11                        -> 74HC173 7
Reset:                                   -> 74HC173 15  (active high)


Counter (advanced 74HC191 based)
================================

In addition for behaving as a simple, latching register it has additional features: ability to
increase and decrease its value.

Wiring
------

Bus:     Arduino (9, 8, 7, 6, 5, 4, 3, 2) <-> 74HC245 (11, 12, 13, 14, 15, 16, 17, 18)
Out:     Arduino 12                        -> 74HC245 19
Load:    Arduino 13                        -> 74HC02  3
Clock:   Arduino 11                        -> 74HC191 14 (rightmost chip)
Reset:                                     -> 74HC02  5 (active high)
Up/Down:                                   -> 74HC191 5
Count:                                     -> 74HC191 4