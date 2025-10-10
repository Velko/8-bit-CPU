8-bit-CPU
=========

After watching [series of videos][eater-net-8bit] by Ben Eater building an 8-bit computer from scratch,
I was hooked. Various thoughts for improvements and experiments was running through my mind. But first
I have to build one. Improvements will come later. Whom am I kidding? I'll never be able to build an
exact replica, I'll incorporate improvements as I go.

In contrast to Ben, I'm not that crazy about building the whole thing on breadboards. PCBs are fine,
I like them, but building the whole thing on single board takes away the flexibility. So the plan is
to make a small board for each module and connect them together.

I plan to build a prototype module on breadboard, play around with it and then design and make a PCB
for it. It might also be interesting to make the boards little customizable (leave a chip out, create
a solder bridge, use shorter connector) so that they can be re-used for different purposes.

Of course, some parts of it might stay on a breadboard forever, or I might choose to create PCBs for
those as well. I don't know, time will tell. But the main idea is that it should be possible to swap
out PCBs for breadboards and vice versa.



Key differences from Ben's version
==================================

256 bytes of memory
-------------------

I felt that 16 bytes of total memory might be too tight, went for 8-bit addressing and 256 bytes
of memory straight from the beginning. "Real" 32 KiB SRAM chip is used, with remaining higher address
lines tied to ground. Expanding to 256 bytes does not introduce more complexity, I think that it even
made things easier. The emulated version has (and is able to use) 64KiB of memory, hardware version
has not catched up with it yet.


ROM and bootloader mode
-----------------------

I was not in the mood for _any_ DIP switch toggling for program entry, so I added an EEPROM instead.
Still I did not want to go full Harvard architecture with separate program and data memories, so
there's bootloader mode instead.

To enable it, RAM's Chip Enable is connected together with Write Enable, while ROM's Chip Enable is
connected with Output Enable of the RAM. What happens is that all reads comes from ROM and all writes
goes into RAM.

I have bootloader code in the beginning of the program that copies contents of all 256 bytes into RAM
and then patches itself (in RAM) to be skipped. It is nice to have more memory, since in original
version there are only 16 bytes total, but I can afford to _waste_ similar amount on bootloader.

In _run mode_ ROM's Chip Enable is tied to disabled state permanently, while RAM is permanently enabled.

4 flags
-------

In addition to Z and C flags, there are Negative and oVerflow flags. Took an inspiration from
[AVR Instruction Set Manual][avr-instructions], on how to implement various branching instructions.
N and V flags are required for some. N bit is just a copy of 7-th bit of the result. oVerflow indicates
that the sign bit "overflowed" as a result of addition/subtraction. In short it can be defined as:
*If sign bits of both addition operands are equal, but sign bit of the result is different, the overflow
occured.*

C flag got an additional update to act as a Borrow bit in subtraction. It behaves same way as in
Z80 / AVR / x86 processors. In subtraction the meaning of C is opposite from 6502 or Ben's version,
I find this more intuitive.


256 opcodes
-----------

As memory was expanded to 256 bytes, it was not possible to encode opcode and address in single byte
anymore. Instructions may require multiple bytes anyway now. Instruction Register loads 8-bit opcode and
extra arguments are fetched from RAM when needed, there's room for 256 opcodes.

However, number of opcodes is also limited by capacity of control EEPROMs. 8 bits for opcode + 4 bits
for flags + 3 bits for instruction step = 15 address lines. This calls for 32K EEPROM - 28C256. They
felt a little pricey when I ordered parts and I was not completely sure if I'll really need them. For
now I only have 28C64 chips, limiting number of opcodes to 64. It is still 4 times more than in Ben's
version.

There are plans to support "extended" opcodes (up to 512, or even more, if required). Planning to switch
to SST39SF010A chips for microcode ROMs. These have more capacity (and address lines) and are a bit
cheaper as well.


Modular ALU
-----------

Currently there are 2 ALU modules: Add/Subtract (with or without carry/borrow),
and AND/OR. 2 more modules are about to come - XOR/NOT, Shift/Nibble-swap.


Flags register as an independent entity
---------------------------------------

Zero flag's calculation takes input from the Bus, instead of being embedded in ALU module. This allows
to add additional ALU modules and keep just one instance of Z calculation circuitry. Additionally, it
is possible to calculate flags for anything on the Bus, for example - while loading byte from memory.
There's additional function for flags register to be sent and loaded from bus directly. Currently
there is no use for that, but it may become handy if flags need to be saved and restored for some reason
(perhaps, to implement interrupts).


Double-latching registers
-------------------------

One of the main sources of instability in Ben's design is that registers' "tap outputs" (ones that
connects registers to ALU, RAM or Control Logic) change immediately when new value is latched.
This is especially important with Flags and Instruction Register, as it creates the infamous
"EEPROM noise" on the rising clock edge, when it can cause unexpected effects. It might not be such
an issue for general-purpose registers or MAR, but it is better that everything holds steady while
the clock line is high.

The double-latching technique adds additional D flip-flops between register's primary ones and its
"tap output". These additional flip-flops are configured to latch on the inverted clock, therefore
output stays unchanged until the falling edge.


Dual-output registers
---------------------

General purpose registers got dual 3-state "tap outputs". Instead of ALU inputs being hardwired to
registers A and B, now (with appropriate control signals) it is possible to connect them differently,
for example do A + A directly. It also allows additional registers (C and D), that could be used
with ALU directly. Currently this feature is not used and control lines are wired for steady "on",
but the potential is there.


Quarter-clock
-------------

One of the sources of instability in Ben's version is RC-circuit used as an edge detector in RAM
module. A common technique is to isolate the circuit using extra logic gates, so that it does not
send spikes back in clock line. I, however, decided to eliminate the need for edge detection
completely. The thing with RAM is that it will keep loading the value all the time while Write Enable
line is enabled. If inputs change, the last value will be stored, which may not be one we want if
Write Enable is disabled on same moment as other control lines starts to change. Ben solved it using
edge detector circuit, I went in another direction and introduced a "dead time" between moment when
primary clock line goes low and inverted clock rises.

Added a counter (could have been anything that can divide the frequency) and few NOR gates on the
*clock module* I generate two 25% duty-cycle clock signals, that are offset by half of the cycle. It
looks like this:

![q-clock](./doc/q-clock.png)

Part of the cycle when both clocks are low ensures that RAM's Write Enable is not active when control
lines or bus changes.

While it is required only by RAM module, I see no downsides for using it globally (it might be an issue
at high clock frequencies, though). Also, now other un-clocked parts (e.g. 193 counter for Stack Pointer)
can be introduced without worries.


Muxed control lines
-------------------

A great way to save bits in Control EEPROMs is to add demultiplexers, which activates just a single line
from several. For example, by using 74*138 demultiplexer one can expand 3 bits to 7 control lines
(technically - to 8, but you need to reserve one as "unused"). Currently there are 2 demultiplexers
used - for OUT and for LOAD lines. For OUT it also prevents "invalid" conditions, such as multiple
modules trying to output value on the bus.

While, in theory, there might be need to load same value into multiple modules simultaneously, I've
not yet encountered one, and I'm happy to live with that limitation.


No MAR, separate Address Bus
----------------------------

While trying to adjust the architecture for 16-bit memory space, I found out that having a single
Main Bus and Memory Address Register comes with performance penalty, as all address transfers takes
more cycles.

After some experimentation I found out that the most optimal solution is to remove the MAR entirely
and have a separate 16-bit Address Bus, connected directly to the RAM chip(s).

Now, for example, Progam Counter can put an address on this bus, and the data is available to be sent on the
Main Bus.

Additionally, I re-designed PC in a way, that it can output the "old" value on the Address Bus, and
increment itself simultaneously. As a result, I can reduce the fetch stage of each instruction to just
single cycle.

There are some situations (like JMP instruction), when data should be exchanged between Address and
Main buses. There's a pair of special Transfer Registers, that allows to transfer low or high bytes
between the buses.


Arduino + Python test module
----------------------------

It started with hooking up an Arduino (on its own at first, then expanded output with 595 shift registers,
expanded even more with 139 demultiplexers and finally added 165 for expanded input) and writing some
sketches to verify if modules work as expected. Soon I realized that the environment is a bit limited
and while it can prove that everything works, it is not very helpful for diagnostics.

Reducing the functions of Arduino to "set control lines", "put to bus", "read from bus", "read flags",
"pulse a clock", etc. and implementing higher level logic in Python, makes it more flexible and quicker
to develop. Wrote a "client" that uses interactive input for diagnostics.

Started to implement Python functions that acts as an assembly instructions - for example: add(A, B)
switches all control lines and issues clock ticks as needed for the addition operation. Basically -
implemented microcode in Python. Later, with refactoring it became my main microcode definition and
is used as primary source for microcode EEPROM contents.

Using the instruction-like functions and [pytest][pytest] framework wrote a quite thorough test suite.
It can check couple hundred scenarios in just few seconds and point out if something does not work as
expected. It has already saved me several times, when I did some rewiring.

At the moment the test module is swapped out for "real" EEPROM-based Control Logic, but I'll definitely
find a way to use both of them in parallel, as it is too useful to be retired.


Programmed using CustomAsm
--------------------------

There was Python-based "assembler" at first, but in the end I adopted [CustomAsm][customasm] for
machine code generation. There's an utility that takes my microcode definition and exports a file,
describing them for [CustomAsm][customasm]. It takes it from there.


Debugger & IDE
--------------
As the Test module allows great deal of flexibility, I was able to also develop a simple debugger.
It can examine registers, RAM contents, single step. Addition of BRK instruction and corresponding
control line introduced ability to set breakpoints and run the program in full-speed. Unfortunately
it only works with emulator, as current hardware doesn't support both "normal" Control Logic and
Test modules connected simultaneously.

Later I went even further and developed a simple IDE, that allows basic code editing, integrates
with [CustomAsm][customasm] for compilation and has basic debugging functionality. One can single-step,
set breakpoints, examine registers. The IDE is far from polished experience, still it is useful.


Side-projects: EEPROM and Flash writers
---------------------------------------

As side projects, there are 2 boards (Arduino Uno shields), firmware and client utility for
programming DIP-28 and PLCC-32 EEPROMs (AT28C64 and AT28C256), as well as PLCC-32 Multi-Purpose
Flash (SST39SF*).

EEPROM board has additional headers, giving access to address and data pins, allowing the board to
act as a Test module, when connected to the Main Bus and control lines.

File upload and download uses XMODEM protocol, can be used with any terminal emulator. There's also
a (*nix-only) command-line client utility for convenience.


Emulated in Verilog
-------------------

In order to be able to work with the software side of the project, when hardware was not available,
I wrote an in-Arduino emulator, that speaks same protocol as Test module. With time that proved to
be insufficient, as Arduino was still needed, so I ported the C++ code to run on PC. It worked fine,
but was a hand-crafted approximation of the CPU, so I could not really test all "what if" scenarios
I'd like to.

So I decided to build another emulator, using proper hardware description language - [Verilog][verilog].
The idea was that I first make "building blocks" - (hopefully accurate) implementations of 74-series
logic chips, and then connect them together into CPU modules. This way I get a runnable representation
of the thing, how it should be built with real chips.

To provide connectivity with (virtualized) serial port, I built additional [VPI][vpi] module.


Repository index
================

* **.github** - configuration files for GitHub integration, e.g. workflows for GitHub Actions
* **.vscode** - configuration for Visual Studio Code
* **arduino** - Arduino sketches and C++ code, to help test and automate things
    * **bouncyy** - software button debouncer and "rebouncer"
    * **pincontrol** - substitute Control Logic. Controlled via serial link from **pycontrol**
    * **xmprog** - EEPROM/Flash programmer, file upload using XMODEM protocol
* **demo** - demo programs
* **doc** - some (mostly outdated) design thoughts, BOM, etc.
* **emulator** - hardware emulator in Verilog
    * **chips** - Verilog descriptions of (mostly 74xx) chips
    * **cpu-modules** - "wired up" CPU modules
    * **tests** - test benches for chips and modules
    * **vm** - a "virtual machine". Speaks same protocol as **pincontrol**
* **hardware** - hardware schematics, boards, etc.
    * **breadboard** - Fritzig projects for some modules
    * **pcb** - KiCad schematics and boards
        * **alu_back** - backplane board for ALU and GP registers
        * **aunit** - Arithmetic Unit (ALU module for addition and subtraction)
        * **clock** - (unfinished) Clock module
        * **control** - (unfinished) Control Logic
        * **counter** - Program Counter
        * **display_back** - backend board for Output module (7-seg display)
        * **display_front** - frontend board for Output module (7-seg display)
        * **eeprom_burner** - EEPROM writer as Arduino Uno shield
        * **flags** - Flags register
        * **flash_writer** - Arduino Uno shield - writer for SST39SF0*-series Flash chips (chosen EEPROM replacement)
        * **keyboard** - (unfinished) 4x4 keyboard scanner module
        * **lunit** - Logic Unit (ALU module for AND and OR)
        * **modules** - Register, ALU, etc. boards as KiCad footprints (for backplane)
        * **ram** - (unfinished) RAM module
        * **register** - GP register
        * **sunit** - Shift Unit (ALU module for shift and nibble swap)
        * **transfer** - transfer register (between Main Bus and Address Bus)
* **include** - C and .def files for inclusion on other programs
* **misc** - miscellaneous utilities
    * **digits** - an utility to generate binary ROM image for 7-segment display
    * **xmclient** - PC-side client utility for **xmprog**
* **parts** - custom KiCad symbols and footprints for missing components
* **pycontrol** - Python-based control logic, microcode, tests, demo programs, etc.
    * **ide** - a simple PyGTK-based IDE with graphical debugger
    * **libcpu** - main implementation of control logic, microcode
    * **stubs** - MyPy type definitions for packages that lack those
    * **tests** - PyTest scripts, testing (real or emulated) hardware and PyControl itself
    * **tools** - various tools that generates microcode, customasm definitions, execute and debug binaries
* **simulation** - [Logisim][logisim] and [Digital][digital] simulations for tricky logic

Progress
========

* Created Github project and added few most immediate tasks
* Wrote an introductionary README (this one ;-) )
* Decided on overall design
* Compiled list of modules and parts for first experiments, placed an order with my favorite supplier
* Found Arduino, breadboard and few 7-segment displays at home. Time to practice!
* Built breadboard prototypes for Clock, Register, Counter, Display and EEPROM burner
* Built ALU, complete with upgraded Flags register.
* Wrote some [blog posts][velkoraspi] about the "adventures"
* Arduino-based testing device. Connect the module, run a command and it verifies that module works
  as expected.
* Designed, soldered PCB versions of Register, ALU, Flags and EEPROM programmer
* Reworked testing device - moved most logic to "client" side. Coding in Python is a lot quicker
  than constantly re-flashing the Arduino. Can use unit-test framework, use debugger, quick edits.
* Beginnings of instruction set.
* Soldered 2 more Registers, to be used as MAR and IR
* Built breadboard prototype of RAM module (placed MAR and IR on it), wrote some unittests for it
* Wired both ALU and RAM blocks to Arduino, merged test suites
* Hey, it can calculate and there's memory. That should be enough to do something more complex.
* Developed Sieve of Eratosthenes - calculate prime numbers up to 256. A Python program, which uses
  assembly-like functions to manipulate the ALU and RAM modules. All variables/arrays required for
  algorithm are stored in the RAM. The control flow reads its input only from Flags register. This
  should be almost 1:1 translatable to assembly / machine code
* Play around with Python AST visitor to automatically "flatten" the program and add necessary labels
  and jumps to replace Python's while/if/continue/break control flow. When executed, this program generates
  machine code.
* Built a dedicated "debug control" board using Nano, shift registers and demultiplexers
* Connected Program Counter and "read-back" from IR into Arduino. Should be able to "run" programs from
  memory
* Developed a Python-side instruction interpreter, which uses input from IR and flags to select and
  execute appropriate microcode steps. Now it really runs machine code, albeit using weird (and very slow)
  control logic
* Developed utility that dumps current microcode (Python) definitions to C arrays.
* Wrote an Arduino-side instruction interpreter that uses the C microcode arrays and input from IR and
  Flags. Now can run programs without Python-side involvement
* Added an EEPROM in RAM module. Added a bootloader code in the Prime Sieve demo. The bootloader copies
  contents from ROM into RAM and patches itself to be skipped next time
* Implemented a "quarter clock" on the Clock board. Now it produces two 25% duty-cycle clock signals,
  instead of two 50% ones. This should eliminate need for edge-detection circuitry in RAM module.
* Built an EEPROM-based control board. Flashed microcode into ROMs.
* Swapped out Arduino-based control board with EEPROM-based one. A very error-prone operation, I must admit.
* IT'S ALIVE!!! The Sieve of Eratosthenes runs without involvement of any additional processor!
* I pushed it for speed. Initially there were some instability, but I noticed that connection of N flag
  from Flags to Control Logic was loose. Nothing in the code uses N flag for now, that's why it did not
  fail immediately. Once that was fixed, it appears to be rock-solid. I even pulled the capacitor from the
  astable clock, making it go as fast as it can. It's been running that way for over a week - not a single
  misstep.
* Some shooting, video editing and [announcement on Reddit][first-announce].
* Working on updated versions of boards, as there were design issues
* Improving reliability of Python code by adding type annotations
* Wrote emulators. Python-side instruction interpreter for quick code debugging and in-Arduino hardware
  emulator. These should help to move software side forward while there is no combined Arduino- and
  EEPROM-based control logic.
* Fixed/redesigned new versions for Arithmetic Unit and Flags boards. An experimental ALU backplane.
* Extended in-Arduino hardware emulator to 16-bit addressing. An easy way to check out various ideas
  before actually building the hardware.
* Adopted [CustomAsm][customasm] for machine code generation. Can retire my own Python-Assembly.
* Developed a debugger (breakpoints, single step, live register inspection).
* Designing additional ALU modules, miniaturized Display module.
* Ported hardware emulator to run on PC. Configured GitHub Actions to run tests.
* Designed boards for AND/OR unit, Display module, Program Counter, Transfer Register, Flash Writer
* Started re-trace branch. Software side and emulation has progressed quite far since first demo.
  On the hardware side, new boards are just starting to roll in, and I need microcode and programs
  to test the build. Can not really just follow the original version history path, because then I
  will not have access to latest software improvements. (CustomAsm, MyPy, etc.), Instead I took the
  "latest and greatest" and removed all features that are not supported by hardware yet. Will gradually
  add those back as I assemble the CPU.
* Replaced the hardware emulator with one developed in Verilog. Implemented 74-series chips as basic
  building blocks. The rest of the machine is "wired up" from those blocks. It gives a runnable version
  and represents how it can be built on breadboards or PCBs. Same as previous implementation, it can
  be controlled via virtual serial connection.
* Merged EEPROM burner, Flash writer and XMProg firmwares into one. Now it can program EEPROMs and Flash
  ROMs (should plug in the right Arduino shield) from binary file uploads over XMODEM protocol.
  Interestingly, something in Arduino library was interfering with serial communication, so everything
  was ported to C and depends on [AVR-Libc][avr-libc] only. The built-in functionality of content
  generation for 7-segment display and microcode ROMs were ported to separate utilities.
* Developed a simple IDE / GUI debugger. Probably I should've created a VSCode extension, but it I feel
  more comfortable in creating a whole app in PyGTK.
* Designing "universal" I/O controller, up to 64 (or 256) ports for external devices.


[eater-net-8bit]: https://eater.net/8bit
[velkoraspi]: https://velkoraspi.blogspot.com/
[avr-instructions]: http://ww1.microchip.com/downloads/en/devicedoc/atmel-0856-avr-instruction-set-manual.pdf
[pytest]: https://docs.pytest.org/en/stable/
[first-announce]: https://www.reddit.com/r/beneater/comments/loy9kj/important_milestone_it_works/
[customasm]: https://github.com/hlorenzi/customasm
[digital]: https://github.com/hneemann/Digital
[logisim]: http://www.cburch.com/logisim/
[verilog]: https://en.wikipedia.org/wiki/Verilog
[vpi]: https://en.wikipedia.org/wiki/Verilog_Procedural_Interface
[avr-libc]: https://www.nongnu.org/avr-libc/user-manual/index.html
