Random thoughts
===============

* All registers are almost identical - can use same board
* Ribbon cable seems to be a good candidate for bus
* Need bus/breadboard connector
* is there a need for PCBs to be "pluggable" into breadboard?
* MAR can be either simple latch register or use same as for PC. It might be useful to have a simple
  feature to advance to next address. Could be useful when loading initial memory contents.




There are also 556 dual timer, that might be nice for the clock. And there are TLC551 and TLC556
versions - single and dual.


Consider writing a Python clients for Arduino-based tools, as full-featured onboard command
interpreter appears to be a bit complicated to write.



Notes for blog
==============


* what was at home
* 7-segment display tests
    * additional tools
    * Rants about IDE
    * LOL from Arduino


* ordering and delivery
    * parts list
    * warehouse rules
    * delivery speed
    * substitutions


* building clock
    * TS555 chips (all 3 if them) that I had at home proved to be unstable - changed the oscillating
      frequency wildly, I suspect they picked up some ambient EM noise or something, because
      touching various parts (chip itself, capacitors) of the board triggered/cancelled it. Another
      power supply or added decoupling capacitors did not help. Not sure whats wrong with them.
      Newly ordered LM555s seem to work fine.
    * Solved: I forgot to wire up RESET pin, but since TS555 is a CMOS one, floating input pins are
      unpredictable. Actually - since the whole build is with HC chips, I should probably stick to
      these.
    * thoughts about unhalting
    * The toggle switch I ordered is not what I ment, but still would work with SR latch
      will not stay in the breadboard tho. Using a jumper and 3 pins instead.
    * Ampermeter burnout and current / voltage worries
    * Innovation with NOR gates

* building display
    * use clock module temporarly
    * testing using Arduino
    * switch to standalone 555 and flickering

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
