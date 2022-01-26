Overall design
==============

The overall structure starts out same as used in breadboard computer built by Ben Eater. It has,
however, evolved quite a lot away from it.

+------------+  +------------+------------+
|     PC     |  | Register A |   Add/Sub  |
+------------+  +------------+------------+
|     LR     |  | Register B |   And/Or   |
+------------+  +------------+------------+
|     RAM    |  | Register C | Shift/Swap |
+------------+  +------------+------------+
|     TH     |  | Register D |   Xor/Not  |
+------------+  +------------+------------+
|     TL     |  |    Flags   |     ?      |
+------------+  +------------+------------+
|     SP     |
+------------+
|    ACalc   |
+------------+

+------------+
|     IR     |
+------------+

+------------+
|    OUT     |
+------------+



Each module eventually will be implemented as PCB. All modules should be plugged into a back-bone
PCB, that provides bus connectivity, power and control signals. Module PCBs should be designed in
a way that allows them to be plugged into breadboards.

Planned modules are:
* CLK          - clock
* Register A-D - general purpose registers
* Add/Sub      - ALU module for addition and subtraction
* And/Or       - ALU module for bitwise AND and OR
* Shift/Swap   - ALU module for bit shift and nibble-swap
* Xor/Not      - ALU module for bitwise XOR and negation
* Flags        - flags register
* PC           - program counter
* LR           - link (return address) register
* RAM          - memory
* TH/TL (TX)   - transfer register (between Main and Address buses)
* SP           - stack pointer
* ACalc        - address calculator (for relative addressing)
* OUT          - numeric output register
* IR           - instruction (decoder) register

* DSP   - display
* IN    - input device
* CTRL  - control unit
* BUSM  - bus monitor
* TEST  - Arduino-based test module

Registers
=========

General purpose registers A, B, C, and D should be able to load 8-bit value from the bus, output it
back and provide two 3-state "tap" outputs for connecting them to ALU argument buses.

Additional requirement here is that "tap" outputs should stay constant for the whole first part of
clock cycle, even if new value is loaded. This can be achieved by second stage of D flip-flops, that
loads data from primary stage on rising edge of inverted clock.



Minimal implementation
----------------------

All registers are built using 74HC173 register chips, and 74HC245 as output buffers.

As GP register can be re-used for another purposes (e.g. Instruction Register), PCB footprints can
be kept unpopulated, if there is no need for particular feature.


Buses
=====

In contrast to Ben's computer, this design features several buses:

* Main Bus      - 8-bit bus, connecting registers, ALU outputs, RAM data. This is equivalent to
                  "The Bus" in Ben's design;
* Address Bus   - 16-bit bus, connecting PC, SP, TX, etc. to the RAM address. It replaces Memory
                  Address Register in Ben's design, connecting RAM directly to address source without
                  wasting extra clock cycles;
* ALU arg Buses - a pair of 8-bit buses, connecting GP register "tap" outputs to Left-hand and
                  Right-hand argument inputs of ALU modules. This allows use of arbitrary GP register
                  for any argument. In Ben's design, register A was always connected to Left and B
                  to the Right argument input of ALU;
* Flags minibus - 4-bit bus, linking ALU modules to Flags register. There are Carry-In, Carry-Out,
                  oVerflow and Zero signals;



Obsolete information follows, should be actualized
====================================================================================================

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
