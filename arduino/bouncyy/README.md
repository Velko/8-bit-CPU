Bouncyy
=======

A small tool for switch de-bounce and external debouncer testing. It takes an
input from switch, performs debouncing in software and outputs clean signal.

Also it generates another output, that is guaranteed to bounce few times.
This signal is intended to test if other (e.g. 555-based) debouncers are up
to the task. Mechanical switches are unpredictable and may or may not introduce
noticable bounces, but this tool will do.

It is implemented using "Arduino Femto" (bare ATtiny25 chip), but it should be
easily portable to larger Arduino boards.


Wiring
------

The device is a bare ATtiny25 chip, it requires only power and ground. Input
and output should be wired as follows:

* PB2 - switch input (active low, pull-up enabled)
* PB0 - debounced output (active high, debounced)
* PB1 - re-bounced output (active low, guaranteed bounce, copies button)


Programming
-----------

ATtiny should be wired to external programmer - it is required to connect MISO,
MOSI, SCK and RESET pins.

The Makefile is configured for [USBasp][usbasp] programmer, but it should be
possible to adapt it easily for other devices.

When fresh ATtiny is programmed, it is necessary to adjust its _fuse bits_, as
the default setting is to run it using internal 1 MHz clock. While it could have
been enough for this application, I prefer to switch the clock to 8 MHz mode. The
command for this is:

    make fuses

The firmware can be uploaded using command:

    make upload


[usbasp]: https://www.fischl.de/usbasp/
