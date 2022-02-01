Random thoughts
===============

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
256 instructions - 8 bits
  8 stages       - 3 bits
  4 flags        - 4 bits
---------------------------
                 15 bits  = 28C256 EEPROM
                 no room for word select

Expand further:
512 instructions - 9 bits (IR + ext.bit)
  8 stages       - 3 bits
  4 flags        - 4 bits
---------------------------
                 16 bits  = SST39SF010A
                 one extra address bit



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


* Order 2
    * Ran out of breadboards
    * 556, NANDs, breadboards
    * do I needed to order JK flip-flops as well?

* Keyboard
    * Rearrange the keys
    * Initial idea
    * Post on Reddit / idea about pin7
    * Latching logic
    * Pair with Display


Far future
==========

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



RAM signals
===========

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



Diagrams
========

https://app.diagrams.net/


Some links
==========
https://alternatezone.com/electronics/files/PCBDesignTutorialRevA.pdf
https://designingelectronics.com/