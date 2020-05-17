Overall design
==============

The overall structure follows the same design as used in breadboard computer built by Ben Eater. The
main difference is that each module eventually will be implemented as PCB. All modules should be
connected together using ribbon cable(s) and few individual control wires.

So, planned modules are:
* CLK   - clock
* PC    - program counter
* A     - general purpose register A
* B     - general purpose register B
* ALU   - arithmetic/logic unit
* MAR   - memory address register
* RAM   - memory
* OUT   - output register
* DSP   - display
* IN    - input device
* INSTR - instruction (decoder) register
* CTRL  - control unit
* BUSM  - bus monitor
* TEST  - Arduino-based test module

Registers
=========

Registers A, B, MAR, OUT and INSTR should be able to load 4 or 8 bits from the bus, output them back
(all or just the lower 4), and provide "taps" for accessing current contents (all or 4-bit groups
individually).

PC is also a register, which can load 4 bits from the bus, output them back. But there's additional
feature to increment value by 1.


Feature matrix:

| Feature |    A    |    B    |   MAR   |   OUT   |  INSTR  |   PC    |
| ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| Out L   |    Y    |    Y    |    N    |    N    |    Y    |    Y    |
| Out H   |    Y    |    Y    |    N    |    N    |    N    |    N    |
| Tap L   |    Y    |    Y    |    Y    |    Y    |    Y    |    N    |
| Tap H   |    Y    |    Y    |    N    |    Y    |    Y    |    N    |
| Incr    |    N    |    N    |    N    |    N    |    N    |    Y    |


Registers, that output only lowest 4 bits, should output highest ones as 0s. Taps should allow
reading all bits stored in register, even if output is disconnected.


Minimal implementation
----------------------

All registers, except PC is built using 1 or 2 74LS173 register chips, and 74LS245 as output buffer.
On PCB some places can be left unpopulated, if there is no need for output or no need for upper
4 bits. Also for upper 4 bits, connections of output buffer should be selectable (between GND and
output of a register chip) by adding solder bridges (or 0-ohm SMD resistors) on the board.
Alternatively, we can use jumpers there.

PC is implemented similarly, using 74LS161 counter and 74LS245 output buffer. PC module should be
pin-compatible with all other registers.


Feature creep
-------------

There's no much room for improvement in regular registers, but quite a lot of features can be added
to the PC.

1. Add room for another 4-bit counter, making it to full 8 bits. Highest 4 bit output values should
   be selectable same way as for regular register. Now this type of register can be used anywhere in
   the system. While it feels like a waste, we could even choose to not build regular, latch-only
   registers at all and use this type instead. But it might come down to cost and variety available.

2. Use bidirectional counters (like 74LS569) instead. While there is only single auto-incrementing
   register planned in the first version of the Computer, we may want to improve on that. If, for
   example, we choose to add a Stack Pointer register later, it might be quite useful feature.



Bus
===

Modules will be connected using a ribbon cable. This should provide compact and convenient
interfacing between different parts of the Computer. In addition to data connections, the cable
could also be used to distribute power and another common signals. To reduce complexity, same pinout
should be used for main and "tap" connections. For some applications only a subset of pins will be
used.

Note that ribbon cables are not normally used for power delivery, but it is still worth a try,
because it greatly reduces clutter of the final system. We might include (initially unppoulated)
headers for additional power distribution if the initial configuration causes issues.


So, there are 8 data lines. If we want to distribute power as well, that takes at least 2 additional
wires. Then there are 2 omnipresent signals: clock and reset. So it takes at least 12 wires to
connect everything.


But let's make it 3 wires for power and ground - that makes it 16 - a nice, round number. There are
additional useful signals which *could* be included there, but it is hard to justify a whole new
omnipresent line, if it actually joins just 2 modules.


Main  bus:

| V | 7 | 6 | G | R | V | 3 | 2 |
| - | - | - | - | - | - | - | - |
| G | 5 | 4 | C | V | G | 1 | 0 |


Legend:
* V - +5V power
* G - ground
* C - clock
* R - reset
* 0-7 - bus data lines

The same layout can be reused for "tap" connections:


| V | 7 | 6 |   |   | V | 3 | 2 |
| - | - | - | - | - | - | - | - |
| G | 5 | 4 |   |   | G | 1 | 0 |


The gap in the middle is minimum space that allows 2 IDC connectors to be connected side by side to
unprotected header. We are providing additional power connections between boards, further reducing
the load on main cable. But there are no need to provide redundancies for clock and reset signals.


The layout allows tap connections to be connected either using full 16-pin cable or interchangeably
by using smaller 6-pin cables.



Clock
=====

Clock follows the same 555-timer based design as built by Ben Eater. Additionally it might serve as
initial power entry point, since nothing runs without clock anyway. PCB version should include
micro-USB socket for that.


Arithmetic logic unit
=====================

Arithmetic logic unit follows same design as built by Ben Eater. It provides just 2 operations -
addition and sutraction. Upon completion, it should include Flags register as well. ALU uses tap
connections to registers A and B to obtain its operands.


RAM
===

Depending on available RAM chips, it might be built either similarly to one built by Ben.
Alternatively, we could go for larger (perhaps 256 byte) module. We will not be able to use more
than 16 bytes from it at the begining, but it might be useful when we advance to improvements stage.

In any case - RAM will use tap connection to MAR register for the address. In contrast to Bens
design, we are not going to provide DIP switch-based programming mode. In earliest stages the RAM
contents will be loaded using TEST module. Later they should be entered using Input device or other
means (storage EEPROM).


Display
=======

Follows same design as build by Ben Eater. Uses tap connection into OUT register for the displayed
value. Depending on EEPROM available, could provide more than 2 display modes.


Input device
============

The final device is planned to consist from 4x4 key matrix for hexadecimal data input. It should be
designed separately as it appears to be quite complex. But it should be built using same techniques
as the Computer (no cheating with microcontrollers).



Control unit
============

The same EEPROM based microcode machine. There might be additional ideas for improvements. 



Bus monitor
===========

A simple board with LEDs, to display current status of the bus data lines.


Test module
===========

Rather than fiddling around with wires or DIP switches to test various scenarios, we can connect an
Arduino to the bus and control lines. It should also speed up loading programs into Computers
memory. Note that this will be only connected during development process. Final project will not
contain any other processors, just Computer itself.
