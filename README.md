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





[eater-net-8bit]: https://eater.net/8bit
[velkoraspi]: https://velkoraspi.blogspot.com/
