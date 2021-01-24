Random thoughts
===============

* All registers are almost identical - can use same board
* Ribbon cable seems to be a good candidate for bus
* Need bus/breadboard connector
* is there a need for PCBs to be "pluggable" into breadboard?
* MAR can be either simple latch register or use same as for PC. It might be useful to have a simple
  feature to advance to next address. Could be useful when loading initial memory contents.


* What about going straight for full 8-bit addressing? And 2-byte instructions? Could get 64 or
  so instructions + more memory
* Can we make switchable RAM/ROM storage for programs???

We can combine 2 138s to get 4-to-16 line decoder, using enable pins

There are also 556 dual timer, that might be nice for the clock. And there are TLC551 and TLC556
versions - single and dual.


Consider writing a Python clients for Arduino-based tools, as full-featured onboard command
interpreter appears to be a bit complicated to write.


To brighten up the displays, MIC2981/2982 alonf with ULN2003 might be useful.


Flags:
------
* Carry - available immediately
* Zero  - NORing + ANDing
* Negative - available immediately
* Overflow - XORing and stuff

C, Z, N, O flags gives us same branching opportunities as AVR architecture

Calculating O flag:
http://teaching.idallen.com/dat2343/10f/notes/040_overflow.txt

!(a xor b) and (a xor s)

(a xor s) and (b xor s)


Zero:

 s0 nor s1 | s2 nor s3 | s4 nor s5 | s6 nor s7
          and          |          and
                      and

Overflow:

 a7 xor b7 |     1     |  a7 xor s7
          xor          |
                      and

 a7 xor s7  |  b7 xor s7
           and


https://www.dcode.fr/boolean-expressions-calculator


Expanded arch:
64 instructions - 6 bits
 8 stages       - 3 bits
 4 flags        - 4 bits
---------------------------
                 13 bits  = 28C64 EEPROM
                 no room for word select


Clock:
------
What if I replace those AND gates with NAND? Still works for selection,
but now those spare NANDs can be used to get the inverted clock...




Registers
---------

It might be a good idea to output register TAP connections via another
D-latch, that holds on to old value and updates itself only on FALLING
clock edge (essentially - uses inverted clock). There are several places
that might suffer some race problems if TAP output changes with the main
register load:

Example:
- Arguments are loaded into registers A and B
- ALU calculates a sum
- on rising clock edge sum is loaded into register A
- TAP output of A changes immediately, causing ALU to re-calculate
- there is no issue for register A, as it is not going to re-load value
  until next clock edge
- if something else is looking at the value on the bus (Flags register,
  for example), there is no guarantee if it will use initial value or
  one after re-calculation;


Additinally, by adding another 74HC173 chips, we can also make TAP output
tri-state, potentially allowing connectin multiple registers as ALU inputs.





Notes for blog
==============


* building display
    * use clock module temporarly
    * testing using Arduino
    * switch to standalone 555 and flickering
    * http://www.ohmslawcalculator.com/555-astable-calculator
    * brightening plans (darlingtons ???)
    * finding the segments/bit experimentally
    * use compiler to prepare the digit bytes
    * sprintf formatting

* EEPROM burner
    * substitute shifter
    * Barely fits - actually doesn't. Relocate to bigger breadboard.
    * thoughts about address lines (crazy layout)
    * Shift using SPI
    * something's unstable. Decoupling
    * converting to separate latch signal

* Register
    * Moving the LEDs
    * Testing from Arduino - read back issues / pull-ups

* Migrating to Python command interpreter
* Trying KiCad
* Issues with multiple sketches in VSCode extension - verify + upload

* U/D Counter
    * more versatile (8-bit, up / down)
    * issues with reset
    * missing edge detector
    * inverse clock also useful, could save one NOR gate
    * probably needed some NANDs as well
    * https://logic.ly/demo
    * worries about RC edge detector
    * better part, but unavail: 74x169
    * https://en.wikipedia.org/wiki/List_of_7400-series_integrated_circuits



* Wire up
    * Clock, counter, display

* Order 2
    * Ran out of breadboards
    * 556, NANDs, breadboards
    * do I needed to order JK flip-flops as well?

* ALU
    * Lots of wiring
    * miswired b1 (same as carry in) for H adder chip
    * put everything together, run with counter as reference

* Simple counter
    * Decided to build simple counter as well

* 4-to-16 decoder using 2x 3-to-8 decoders + using enable lines carefully
    * POC build

* Testing using Arduino
    * U/D counter unstable when Arduino switches CE and U/D
    * rewired to use parallel clock and ripple carry

* Rebuilding clock
    * Using 556
    * NAND gate
    * timer's reset lines
    * halt override
    * using 2 buttons instead of switch
    * ensuring startup state
    * do I need "centralized" edge detector / lines?

* ALU improvements
    * adding zero-detect
    * Overflow flag + idea from James Sharman
    * Carry in, carry out
    * Clock still bounces
    * Clock mode jumper not staying in place, replace with 3x2 header
    * thoughts about zero-detector on bus, flags register as separate device
      in case we add bitwise operations
    * 6502 / Z80 mode
    * Cheats for Zero flag

* Testing ALU
    * initializer_list
    * Lack of wires, not even for N flag
    * SDA, SCL == A4, A5
    * a shift register could help a little
    * abstracting the pins
    * add shift register outputs
    * idea about combined eeprom burner / IO extender

* Register updates
    * James Sherman
    * Additional latches for TAP connections
    * Possible Race for flags

* Documenting the builds
    * Fritzig, adding ICs
    * Version-control unfriendlyness
    * Kicad vs Eagle



* Keyboard
    * Rearrange the keys
    * Initial idea
    * Post on Reddit / idea about pin7
    * Latching logic
    * Pair with Display


Far future
==========

These ideas should be addressed *after* the basic CPU is working. But I should keep writing them
down as they appear.


Multiplex Output bits
---------------------

Only one device should be allowed to output data onto the bus. But microcode now reserves a bit for
each. Since only one can be enabled, we can encode *which* one. This way, using just 3 bits we can
encode up to 7 devices on the bus.


8-bit addressing and larger RAM
-------------------------------
There are no architectural restrictions on having 8-bit Memory Address Register. It is, however, not
possible to put a value there using original instruction set.

Additional LS/ST instructions using indirect address from register B may overcome that.

It might be possible to use 8-bit PC and use PC-relative addressing. This also introduces relative
jumps.

Major re-design of MAR and PC is necessary - should be able to add to existing contents.


Input device / bootloader
-------------------------

Add input device to provide data / help with programming. Make the Computer execute bootloader code.

Needed features:
* in this mode instruction fetch reads from ROM instead of RAM (additional bit in microcode?)
* "unhalt" the clock
* read from I/O device into A
* store A into address pointed by B
* add immediate to B
* (optional) load conents from address pointed by B into A


What about creating an input device that scans 4x4 array of buttons. Use ready-made 4x4 keypad
matrix. May need to re-label it for hex digit input.

Clock + 4-bit counter, 2-to-4 decoder, 4 ANDs, Quad-OR can detect key-press. 2x 4-bit registers, to
latch in the value. Evaluate if it is possible to move current values from A to B while loading new
into A. Also need a way to get single clock pulse when key detected (wasn't there something in the
Bens videos???).



Variable-length instruction opcodes
-----------------------------------
There are only 16 possible opcodes. Some do not need arguments at all, others would greatly
benefit from longer immediate values. It might be possible to vary which bits goes out to bus
and which are used for microcode addressing. But I suspect that complexity increases greatly.

It appears that simpler option would be just swich to 16-bit instructions. That will provide enough
space for full 8-bit operands and allow up to 256 instructions. In combination with that, we might
switch to 256 byte RAM.


RAM signals
-----------

RAM:

* ~OE~
* ~WE~

Buffer:

* ~OE~  - ~BOE~
* DIR

DIR HIGH -> A2B (up)
    LOW  -> B2A (down)

do nothing (display current):
   ~OE~ = LOW
   ~WE~ = HIGH
   ~BOE~ = HIGH
   DIR  = dont care

read from RAM:
   ~OE~ = LOW
   ~WE~ = HIGH
   ~BOE~ = LOW
    DIR = HIGH

write to RAM:
    ~OE~ = HIGH
    ~WE~ = LOW  (clocked)
    ~BOE~ = LOW
    DIR = LOW

for easier wiring - flip the buffer around, so the ~OE~ and DIR are same
can connect them together then


Control signals for RAM

RAM Out: active low
RAM Load: active low

internal - ~OE~ == DIR

Clock: 25%

Truth table:

OUT | LOAD | CLOCK | Function | BOE | OE | WE
-----------------------------------------------
 H  |  H   |   L   | Nothing  |  H  | L  | H
 H  |  H   |   H   | Nothing  |  H  | L  | H
 L  |  H   |   L   | Out      |  L  | L  | H
 L  |  H   |   H   | Out      |  L  | L  | H
 H  |  L   |   L   | Load     |  L  | H  | H
 H  |  L   |   H   | Load     |  L  | H  | L
 L  |  L   |   x   | invalid  |  *  | *  | *

WE = !(CLOCK AND !LOAD)
OE = !LOAD
BOE = OUT AND LOAD

OE = not(LOAD)
WE = CLOCK nand not(LOAD)
BOE = not(OUT nand LOAD)

OE = not(LOAD)
WE = CLOCK nand OE
BOE = not(OUT nand LOAD)




Clocking 25% duty
=================

        +---+   +---+   +---+   +---+   +---+   +---+
SRC     |   |   |   |   |   |   |   |   |   |   |   |
      __|   |___|   |___|   |___|   |___|   |___|   |___

         +-------+       +-------+       +-------+
/2+D     |       |       |       |       |       |
      ___|       |_______|       |_______|       |______

         +--+   ++       +--+   ++       +--+   ++
AND      |  |   ||       |  |   ||       |  |   ||
      ___|  |___||_______|  |___||______ |  |___||______

       +------------+  +------------+  +------------+
OR     |            |  |            |  |            |
     __|            |__|            |__|            |__

     --+            +--+            +--+            +--
NOR    |            |  |            |  |            |
       |____________|  |____________|  |____________|
