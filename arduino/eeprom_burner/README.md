Formerly EEPROM burner
======================

This set of utilities started out as an EEPROM programmer, inspired by [Ben Eater's one][be-prog].

It was replaced by XmProg programmer, that accepts arbitrary binary files for uploading to EEPROM
and Multi-Purpose Flash chips.

What remains here are 2 small utilities that generate binary image files for microcode and
7-segment display ROMs.

The microcode tool is also a temporary one, it should be replaced by Python tool, generating the
binaries directly from microcode definitions (right now it's: generate C code from Python, then
compile it in this tool).

[be-prog]: https://github.com/beneater/eeprom-programmer
