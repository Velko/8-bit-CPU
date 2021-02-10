8-bit-CPU
=========

After watching [series of videos][eater-net-8bit] by Ben Eater building an 8-bit computer from scratch,
I was hooked. Various thoughts for improvements and experiments was running trough my mind. But first
I have to build one. Improvements will come later.

In contrast to Ben, I'm not that crazy about building the whole thing on breadboards. PCBs are fine,
I like them, but building the whole thing on single board takes away the flexibility. So the plan is
to make a small board for each module and connect them together.

I plan to build a prototype module on breadboard, play around with it and then design and make a PCB
for it. It might also be interesting to make the boards little customizable (leave a chip out, create
a solder bridge, use shorter connector) so that they can be re-used for different purposes.

Of course, some parts of it might stay on a breadboard forever, or I might choose to create PCBs for
those as well. I don't know, time will tell. But the main idea is that it should be possible to swap
out PCBs for breadboards and vice versa.


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
* Developed Sieve of Eratosthenes - calculate prime numbers up to 256. A Python program, that uses
  assembly-like functions to manipulate the ALU and RAM modules. All variables/arrays required for
  algorithm are stored in the RAM. The control flow reads its input only from Flags register. This
  should be almost 1:1 translatable to assembly / machine code
* Play around with Python AST visitor to automatically "flatten" the program and add necessary labels
  and jumps to replace Python's while/if/continue/break control flow. Main idea is to run this program
  with different "backend" that generates machine code from it, instead of sending commands to hardware
  directly
* Built a dedicated "debug control" board using Nano, shift registers and demultiplexers
* Connected Program Counter and "read-back" from IR into Arduino. Should be able to "run" programs from
  memory
* Developed a Python-side instruction interpreter, that uses input from IR and flags to select and
  execute appropiate microcode steps. Now it really runs machine code, albeit using weird (and very slow)
  control logic
* Developed an utility that dumps current microcode (Python) definitions to C arrays.
* Wrote an Arduino-side instruction interpreter that uses the C microcode arrays and input from IR and
  Flags. Now can run progams without Python-side involvement
* Added an EEPROM in RAM module. Added a bootloader code in the Prime Sieve demo. The bootloader copies
  contents from ROM into RAM and patches itself to be skipped next time
* Implemented a "quarter clock" on the Clock board. Now it produces two 25% duty-cycle clock signals,
  instead of two 50% ones. This should eliminate need for edge-detection circuitry in RAM module.
* Built an EEPROM-based control board. Flashed microcode into ROMs.
* Swapped out Arduino-based control board with EEPROM-based one. A very error-prone operation, I must admit.
* IT'S ALIVE!!! The Sieve of Eratosthenes runs without involvement of any additional processor!


[eater-net-8bit]: https://eater.net/8bit
[velkoraspi]: https://velkoraspi.blogspot.com/
