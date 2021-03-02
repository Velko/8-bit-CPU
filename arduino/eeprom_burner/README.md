EEPROM burner
=============

*This sketch is about to have a massive overhaul, as for now it is a quick hack to
fill the EEPROMs with contents for first demo run of the 8-bit Computer. It will be
re-done to allow file upload instead.*

An EEPROM programmer, inspired by [Ben Eater's one][be-prog].

Hardware
--------

For faster operation, hardware configuration is a bit different:

* uses ATmega's internal SPI unit, as it is much faster than shiftOut(). It, however,
  requires that the 595's are wired to specific pins: MOSI, SCK. Another 2 pins are
  also reserved for its operation: SS and MISO
* uses direct port access for data input and output. Data connections were moved to
  Arduino pins 2-9
* OE and CS pins are controlled directly


Software
--------

Programmer drops into command interpreter mode (instead of starting to write immediately).
It waits for a command via serial connection and then performs the requested action.
Currently it can write/verify 4 different ROMs:

* 7-segment display mappings (extended and easy-to-reconfigure version)
* ROM-0 and ROM-1 for Control Logic
* ROM with a demo program

The input sources for last 2 items are generated by external tools.


[be-prog]: https://github.com/beneater/eeprom-programmer