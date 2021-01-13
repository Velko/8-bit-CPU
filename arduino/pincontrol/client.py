#!/usr/bin/python3

import sys, cmd, serial, threading

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)

class TesterClient(cmd.Cmd):
    def do_EOF(self, arg):
        ser.close()
        sys.exit(0)

    def do_identify(self, arg):
        'Identify device'
        send_cmd('I')
        chr = ser.readline().decode('ascii').strip()
        print (chr)

    def do_start(self, arg):
        send_cmd("P0")
        send_cmd("P1")
        send_cmd("P2")
        send_cmd("P3")
        send_cmd("p4")
        send_cmd("p5")
        send_cmd("P6")
        send_cmd("P7")
        send_cmd("M")


    def do_bus_set(self, arg):
        send_cmd("B{}".format(int(arg, 0)))

    def do_bus_get(self, arg):
        send_cmd("b")
        chr = ser.readline().decode('ascii').strip()
        print (chr)

    def do_bus_free(self, arg):
        send_cmd("f")

    def do_ctrl_set(self, arg):
        send_cmd("P{}".format(arg))

    def do_ctrl_clr(self, arg):
        send_cmd("p{}".format(arg))

    def do_ctrl_commit(self, arg):
        send_cmd("M")

    def do_clock_pulse(self, arg):
        send_cmd('c')

    def do_clock_inverted(self, arg):
        send_cmd('C')


def listen_responses():
    while ser.is_open:

        print(chr, end='', flush=True)

def send_cmd(cmd):
    ser.write(cmd.encode("ascii"))
    ser.flush()

if __name__ == "__main__":
    TesterClient().cmdloop()
