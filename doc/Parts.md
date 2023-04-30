Component list
==============

Register
--------

* 2 x 74HC173 - 4-bit register
* 1 x 74HC245 - output buffer
* 8 x LEDs
* 8 x 1kΩ resistors
* 1 x 16-pin IDC header
* 2 x  6-pin IDC header
* 2 x 0.1 μF capacitor
* 1 x 2-pin 1-row socket

Program Counter
---------------

* 2 x 74HC161 - 4-bit counter (or 74HC191 for future features)
* 1 x 74HC245 - output buffer
* 8 x LEDs
* 8 x 1kΩ resistors
* 1 x 16-pin IDC header
* 2 x  6-pin IDC header
* 2 x 0.1 μF capacitor
* 1 x 2-pin 1-row socket

Clock
-----

* 2 x LM555 - timer
* 1 x 1M potentiometer
* 1 x button
* 1 x 74HC08 - AND gate
* 1 x 74HC32 - OR gate
* 1 x 74HC04 - inverter
* 1 x 1μF capacitor
* 3 x 0.1 μF capacitor
* 1 x 0.01 μF capacitor
* 1 x microUSB socket
* 1 x 16-pin IDC header
* 1 x 2-position switch
* 1 x LED
* 4 x 1kΩ resistor
* 1 x 1MΩ resistor
* 2 x 10kΩ resistor
* 1 x 74HC02 - NOR gate

Display
-------

* 1 x LM555 -timer
* 4 x 7-segment displays (common cathode)
* 1 x 74HC161 - counter (alternative: 74HC163)
* 1 x 74HC138 - demux (or 74HC139)
* 1 x AT28C64 - EEPROM
* 1 x MCR7H4H-16RA - rotary encoded switch
* 2 x 0.01μF capacitor
* 2 x 0.1μF capacitor
* 8 x 1kΩ resistor

EEPROM programmer
-----------------

* 2 x 74HC594 shift registers


Keyboard
--------

* 1 x 4x4 keyboard matrix
* 1 x 74HC161 - counter (or 74HC163)
* 2 x 74HC138 demux (or 1 x 74HC139)
* 2 x 74HC173 - output latches
* 1 x 74HC245 - output buffer
* 4 x 10kΩ resistor
* 2 x 74HC02 - NOR gate
* 1 x 74HC08 - AND gate
* 1 x LM555 -timer

... uncertain about the rest, should play around with it first


ALU
---

* 1 x 74HC245 - output buffer
* 2 x 74HC283 - 4-bit adder
* 2 x 74HC86 - Quad XOR gate
* 1 x 4HC02 - NOR gate
* 1 x 74HC08 - AND gate
* 1 x 74HC173 - 4-bit register
* 10 x LEDs
* 10 x 1kΩ resistor
* 1 x 16-pin IDC header
* 4 x  6-pin IDC header


RAM
---

* 1 x 71256SA20TPG - 32kB RAM module (DIP). Is an overkill but there is no smaller available
* 1 x 16-pin IDC header
* 4 x  6-pin IDC header

... uncertain about the rest, should play around with it first

Bus monitor
-----------

* 8 x LED
* 8 x 1kΩ resistor
* 1 x 16-pin IDC header

Control unit
------------

* 1 x 74HC161 - counter (74HC163 might suit even better)
* 2 x AT28C64 - EEPROM
* 2 x 74HC138 - demux
* 8 x LED
* 16 x LED
* 24 x 1kΩ resistor


Builds
======

Stage 1
-------

The plan is to build a breadboard module for some modules, probably reusing the parts for another,
more complex build, after the module is tested.

* clock
* register
* program counter
* ALU

Only "main" components should be ordered. No need for connectors, headers, etc.

Logic chips:
* 5 x 74HC173 - 4-bit register
* 4 x 74HC245 - output buffer
* 5 x 74HC161 - 4-bit counter
* 3 x 74HC08 - AND gate
* 1 x 74HC32 - OR gate
* 1 x 74HC04 - inverter
* 4 x 74HC02 - NOR gate
* 5 x 74HC138 - demux
* 2 x 74HC594 shift registers
* 2 x 74HC283 - 4-bit adder
* 2 x 74HC86 - Quad XOR gate

Other chips:
* 3 x AT28C64 - EEPROM
* 1 x 71256SA20TPG - 32kB RAM module (DIP).
* 4 x LM555 - timer

Mechanical:
* 1 x 4x4 keyboard matrix
* 1 x MCR7H4H-16RA - rotary encoded switch
* 1 x 1M potentiometer
* 1 x button
* 1 x 2-position switch

Optical:
* 4 x 7-segment displays (common cathode) (already have at home)
* bunch of LEDs (various colors)

Extra materials:
* some DIP switches (4 and 8 pole)
* breadboards


I couldn't source 74HC161 at the moment. Will try to use 74HC163 instead.
Also, there's 74HC191. That will give us a nice Up/Down counting capability
(and is a bit cheaper as well).

Grabbed 74HC139 as well - will save some space on board for keyboard build.

74HC161 and 74HC163 differs only on reset functionality (former is async,
latter - sync). For some places it doesn't matter, as I'm not going to reset
it anyway. In Control Logic, it might be even better to have it synchronous.





Additional "fun"
----------------

* EEPROM programmer
* Display
* Keyboard
* RAM


Stage 2
=======

PCBs will be designed and build for most commonly used modules.


Main:
* clock
* register (will need a lot)
* program counter
* ALU
* Flags reg

Additionally:
* bus monitor
* EEPROM burner



Parts for PCBs
--------------

SMD LEDs
SMD capacitors: 10nF, 100nF, 1uF
SMD resistors: 1K, 10K, 1M, 330




Additional parts
----------------
* MIC2981 - source driver
* LED bars
* resistor networks
* Buffers DIP version of those in ALU
* MUX







Side projects
=============
* 1.8432MHz oscillator (try to build UART)
* MC21605H6WK-FPTLW-V2 - LCD screen
* Arduino Nano
* 74HC40105 - FIFOs for UART (Farnell only lists NXP, not produced, there are TI elsewhere)

PCB Order 1
===========

PCBs were designed for EEPROM writer, Arithmetic unit, Register and Flags. Following is the BOM for
each unit. As General Purpose register will be used for Instruction and Memory Address registers,
there should be enough parts to build 4.


EEPROM programmer
-----------------

* 4x disc cap 5mm, 100nF
* 1x 0805 cap 100nF
* 4x PinSocket 1x8
* 2x PinHeader 1x8
* 1x PinHeader 1x6
* 1x PinHeader 1x10
* 1x resistor 10K
* 2x 74HC595 (or 74HC595)
* 1x DIP-28-W socket
* 1x PLCC-32 socket

Arithmetic unit
---------------
* 4x 0805 cap 100nF
* 1x 0805 cap 10μF
* 8x 0805 LED yellow
* 3x 0805 LED green
* 2x 0805 LED red
* 3x PinHeader 1x8
* 2x PinHeader 1x4
* 1x PinHeader 2x2
* 13x 0805 resistor 1K (or 330)
* 2x 0805 resistor 10K
* 2x 74HC283 SOIC-16W_5.3x10.2mm_P1.27mm
* 3x 74HC86 SOIC-14_3.9x8.7mm_P1.27mm
* 1x 74HC08 SOIC-14_3.9x8.7mm_P1.27mm
* 1x 74HC245 SO-20_12.8x7.5mm_P1.27mm
* 1x 74HC125 SOIC-14_3.9x8.7mm_P1.27mm

Register
--------
* 7x 0805 cap 100nF
* 1x 0805 cap 10μF
* 8x 0805 LED yellow
* 4x 0805 LED red
* 3x PinHeader 1x8
* 2x PinHeader 1x4
* 1x PinHeader 2x2
* 12x 0805 resistor 1K (or 330)
* 4x 0805 resistor 10K
* 1x 0805 resistor 100K
* 3x 74HC245 SO-20_12.8x7.5mm_P1.27mm
* 4x 74HC173 SOIC-16_3.9x9.9mm_P1.27mm

Flags
-----
* 6x 0805 cap 100nF
* 1x 0805 cap 10μF
* 4x 0805 LED green
* 4x 0805 LED red
* 1x PinHeader 1x8
* 4x PinHeader 1x4
* 1x PinHeader 2x2
* 8x 0805 resistor 1K (or 330)
* 6x 0805 resistor 10K
* 1x 0805 resistor 100K
* 1x 74HC02 SOIC-14_3.9x8.7mm_P1.27mm
* 1x 74HC08 SOIC-14_3.9x8.7mm_P1.27mm
* 1x 74HC157 SOIC-16_3.9x9.9mm_P1.27mm
* 2x 74HC173 SOIC-16_3.9x9.9mm_P1.27mm
* 1x 74HC125 SOIC-14_3.9x8.7mm_P1.27mm

Total
-----
* 39x 0805 cap 100nF
* 6x 0805 cap 10μF
* 7x 0805 LED green
* 40x 0805 LED yellow
* 22x 0805 LED red
* 5x 0805 resistor 100K
* 24x 0805 resistor 10K
* 69x 0805 resistor 1K (or 330)
* 1x 74HC02 SOIC-14_3.9x8.7mm_P1.27mm
* 2x 74HC08 SOIC-14_3.9x8.7mm_P1.27mm
* 2x 74HC125 SOIC-14_3.9x8.7mm_P1.27mm
* 1x 74HC157 SOIC-16_3.9x9.9mm_P1.27mm
* 18x 74HC173 SOIC-16_3.9x9.9mm_P1.27mm
* 13x 74HC245 SO-20_12.8x7.5mm_P1.27mm
* 2x 74HC283 SOIC-16W_5.3x10.2mm_P1.27mm
* 2x 74HC595 (or 74HC595)
* 3x 74HC86 SOIC-14_3.9x8.7mm_P1.27mm
* 1x DIP-28-W socket
* 4x disc cap 5mm, 100nF - on stock @ home
* 1x PLCC-32 socket
* 1x PinHeader 1x10 - will improvise
* 14x PinHeader 1x4
* 1x PinHeader 1x6 - will improvise
* 18x PinHeader 1x8
* 6x PinHeader 2x2
* 4x PinSocket 1x8
* 1x resistor 10K - on stock @ home

Additional
----------
74HC125 DIP
74HC157 DIP - not on stock
MIC2981
ULN2003
LED bars
resistor networks 1K x 10
MC21605H6WK-FPTLW-V2 - LCD screen
Arduino Nano


Next order
==========

74HC74  - dual D flip-flop with complementary out - for q-clock
More breadboards
74HC193 - up/down counters
74HC595 SOIC (what is in stock)
SST39SF010A - flash (can be slower ones)
More PLLC-32 sockets
RAM SMD - 256 Kbit, 32K x 8bit
2x2 & 4x1 females
SC52-11SRWA/SC52-11EWA - brighter displays (whichever is in stock)
Or smaller - 4 digit one
More yellow Leds, register, buffers
MC14490 - bounce eliminator?


Output module PCB+
=================

* TLC555 timer SOIC
* 100 ohm resistors 0805
*  50 ohm resistors (in case 100 is still too large)
* 10nF capacitors 0805
* SC39-11GWA displays

RAM:
===
https://eu.mouser.com/c/?q=61C1024



Extras
======

47590-0001 Micro USB

613020243121 - right angle receptacle

61301021021 - right angle header
