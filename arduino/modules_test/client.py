#!/usr/bin/python3

import sys, cmd, serial, threading

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)

class TesterClient(cmd.Cmd):
    def do_EOF(self, arg):
        ser.close()
        sys.exit(0)

    def do_demo_register(self, arg):
        'Demo register in a loop'
        send_cmd('r')

    def do_set_reg(self, arg):
        'Send value to register'
        send_cmd("R{}".format(arg))

    def do_demo_display(self, arg):
        'Demo display in a loop'
        send_cmd('d')

    def do_set_display(self, arg):
        'Put a value on display'
        send_cmd("D{}".format(arg))

    def do_set_display_mode(self, arg):
        'Switch display mode'
        send_cmd("m{}".format(arg))

    def do_demo_counter(self, arg):
        "Demonstrate counter (up)"
        send_cmd('c')

    def do_demo_downcount(self, arg):
        "Demonstrate counter (down)"
        send_cmd('u')

    def do_test_register(self, arg):
        "Perform tests for latching register"
        send_cmd('1')

    def do_test_counter(self, arg):
        "Perform tests for counting register"
        send_cmd('2')

    def do_test_udcounter(self, arg):
        "Perform tests for up/down counting register"
        send_cmd('3')

    def do_test_alu(self, arg):
        "Demonstrate ALU"
        send_cmd('a')


def listen_responses():
    while ser.is_open:
        chr = ser.read().decode('ascii')
        print(chr, end='', flush=True)

def send_cmd(cmd):
    ser.write(cmd.encode("ascii"))
    ser.flush()

def identify_device():
    pass
#    ser.read_all()
#    send_cmd('I')
#    devid = ser.readline().decode('ascii').strip()
#    print (devid)
#    if devid != "MTEST":
#        raise Exception("Device is not a Modules Tester")

if __name__ == "__main__":
    identify_device()

    threading.Thread(target=listen_responses).start()
    TesterClient().cmdloop()
