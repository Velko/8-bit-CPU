Overall design
==============

The overall structure follows the same design as used in breadboard computer built by Ben Eater. The
main difference is that each module eventually will be implemented as PCB. All modules should be
plugged into a back-bone PCB, that provides bus connectivity, power and control signals. Another
difference is that memory address width will be 8 bits.

Module PCBs should be designed in a way that allows them to be plugged into breadboards. Designing a
backbone PCB will be one of the final steps.

Planned modules are:
* CLK   - clock
* PC    - program counter
* A     - general purpose register A
* B     - general purpose register B
* ALU   - arithmetic/logic unit
* FLG   - flags register
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

Registers A, B, MAR, OUT and INSTR should be able to load 8-bit value from the bus, output it back and
provide "taps" for accessing current contents.

PC is also a register, which can load 8 bits from the bus, output them back. But there's additional
feature to increment value by 1.


Feature matrix:

| Feature |    A    |    B    |   MAR   |   OUT   |  INSTR  |   PC    |
| ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| Out     |    Y    |    Y    |    N    |    N    |    Y    |    Y    |
| Tap     |    Y    |    Y    |    Y    |    Y    |    Y    |    N    |
| Incr    |    N    |    N    |    N    |    N    |    N    |    Y    |


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

3. Summing register: design a register that can load a value from bus and add another value on next
   clock cycle. Could be very useful for relative addressing.


Bus
===

In the final product Bus will be provided by a backbone board. Until then, however, modules will
be plugged into breadboards.

To help with the connections on this stage, it might be beneficial to design an adapter board that
allows to connect bread-boarded modules using a ribbon cable. 

This should provide compact and convenient interfacing between different parts of the Computer.
In addition to data connections, the cable could also be used to distribute another common signals.
To reduce complexity, same pinout should be used for main and "tap" connections. For some
applications only a subset of pins will be used.

There are 8 data lines. If we want to distribute power as well, that takes at least 2 additional
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
the load on main cable.

The layout allows tap connections to be connected either using full 16-pin cable or interchangeably
by using smaller 6-pin cables.



Clock
=====

Clock follows the same 555-timer based design as built by Ben Eater. However, efforts were made
to reduce the chip count. In current design, only 3 chips remains on the board, but the functionality
is equivalent to the original.



Arithmetic logic unit
=====================

Arithmetic logic unit follows same basic design as built by Ben Eater. It provides just 2 operations -
addition and sutraction. ALU uses tap connections to registers A and B to obtain its operands.

Module contains additional features:
* Carry-In and Carry-Out signal handling (configurable in Z80 or 6502 modes)
* oVerflow flag calculation

The oVerflow flag is useful when performing calculations with signed values. According to
[AVR Instruction Set Manual][http://ww1.microchip.com/downloads/en/devicedoc/atmel-0856-avr-instruction-set-manual.pdf]
it is required to implement instructions like BRLT or BRGE.

More info: http://teaching.idallen.com/dat2343/10f/notes/040_overflow.txt

In short: oVerflow bit should be set if adding 2 numbers with the same sign produces a result with different
sign. Given that sign is bit7 (in case of 8-bit values), it can be calculated using the following formula:

!(a xor b) and (a xor s)


The rules are slightly different for subtraction. But same formula applies if b7 bit is taken from adder's
input, after it has been adjusted by a XOR gate.


It was decided to move Zero flag calculation from ALU to the Flags register itself. For this to work,
the result value should be put onto the Bus.

There are several additional ALU modules planned for other operations:
* AND/OR - provide 2 bitwise logic operations
* XOR/NOT - provide 2 bitwise logic operations
* SHL/SHR - shift operations

ALU modules communicate with Flags register using special "flags minibus". Transmission of Carry-Out
and Overflow flags should be controlled using tri-state buffers.


Flags register
==============

The flags register is expanded to 4 bits: Z, C, N and V:
* Zero     - result of calculation is 0. Register calculates the bit from value currently on the main
             bus;
* Carry    - loaded from the "flags minibus";
* Negative - result of calculation was negative. Register loads bit7 from the main bus;
* oVerflow - loaded from the "flags minibus";


For operations that does not affect Carry and oVerflow bits, the same value should be kept on next load.
An easy way to achieve this is connect the output of the current values back to the inputs using a
resistor.


Flags register should put current value of the Carry flag out to separate line on "flags minibus", for
ALU modules to use. To support operations where Carry flag is ignored (e.g. ADD vs ADC instructions) the 
value should be ANDed with a control signal.


The register provides a tap connection to current value, to be used by Control logic.


Additional feature is to ouput current value of the flags register onto the bus and load back from
it. This will be reguired on future expansion, if interrupts are implemented. Additionally it can be
used for instructions that modifies the flags (e.g. CLC, SEC). The output should affect only 4 lines on
the bus, giving an opportunity for another module to complete the Status Register with another 4 bits
(e.g. I flag).


Flags minibus
=============

The "flags minibus" consists of 4 lines:
* Carry-In  - from Flags register to ALU. Contents of C flags ANDed with "use carry" control signal;
* Carry-Out - from ALU to Flags register. Weakly pulled to current value. ALU should set it by
              activating a tri-state buffer;
* oVerflow  - from ALU to Flags register. Weakly pulled to current value. ALU should set it by
              activating a tri-state buffer;
* Zero      - from Flags register to ALU. Provides value of current Zero calculation. Not strictly
              necessary - just controls a LED on ALU board.


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
value. As 28C64 EEPROM is used, it provides 4 display modes (unsigned, signed, hex, oct). There's
still one unused address line, providing capacity for 4 more modes.

Additional efforts should be taken to provide sufficient display brightness, as driving 7 segment
displays directly from EEPROM / demux is not enough.


Input device
============

The final device is planned to consist from 4x4 key matrix for hexadecimal data input. It should be
designed separately as it appears to be quite complex. But it should be built using same techniques
as the Computer (no cheating with microcontrollers).



Control unit
============

The same EEPROM based microcode machine, as designed by Ben. There are, however, room for improvements.

* use 3-to-8 line decoder to provide OUT signals. Will take less bits on EEPROM, and prevents faulty
  condition, when multiple modules tries to output values on the bus
* use 6 bits from Instruction register, providing room for 64 instructions. In fact, it could be
  designed to take all 8, so that it could be expanded using larger EEPROMs;
* use 4 bits flags register, providing more opportuntities for conditions;


There are 13 address lines for 28C64 EEPROMs, they are used:
* 3 - instruction step
* 4 - flags condition
* 6 - instruction opcode

When expanded to 28C256, there are 15 address lines in total. If same design is kept, the opcode
can be expanded to full 8 bits.

There is no room for "chip select" line, which enabled Ben to write same contents to both microcode
EEPROMs. But that is just a slight inconvinience, compared to potential benefits. Also, I'm not
convinced that 2 microcode EEPROMs will be enough. To add 3rd (and 4th) one and keep the "chip select"
feature, we will need 2 address lines.


Bus monitor
===========

A simple board with LEDs, to display current status of the bus data lines.


Test module
===========

Rather than fiddling around with wires or DIP switches to test various scenarios, we can connect an
Arduino to the bus and control lines. It should also speed up loading programs into Computers
memory. Note that this will be only connected during development process. Final project will not
contain any other processors, just Computer itself.
