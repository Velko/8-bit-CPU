Random thoughts
===============

* All registers are almost identical - can use same board
* Ribbon cable seems to be a good candidate for bus
* Need bus/breadboard connector
* is there a need for PCBs to be "pluggable" into breadboard?





Far future
==========

These ideas should be addressed *after* the basic CPU is working. But I should keep writing them
down as they appear.


Multiplex Output bits
---------------------

Only one device should be allowed to output data onto the bus. But microcode now reserves a bit
for each. Since only one can be enabled, we can encode *which* one. This way, using just 3 bits
we can encode up to 7 devices on the bus.


8-bit addressing and larger RAM
-------------------------------
There are no architectural restrictions on having 8-bit Memory Address Register. It is, however,
not possible to put a value there using original instruction set. 

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


Potential input device - a 4+1 keyboard ( keys for base-4 input + enter) combined with 7-seg output
display. Next version!




Variable-length instruction opcodes
-----------------------------------
There are only 16 possible opcodes. Some do not need arguments at all, others would greatly
benefit from longer immediate values. It might be possible to vary which bits goes out to bus
and which are used for microcode addressing. But I suspect that complexity increases greatly.


