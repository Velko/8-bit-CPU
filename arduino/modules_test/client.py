#!/usr/bin/python3

import sys, cmd, serial, threading

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)

class TesterClient(cmd.Cmd):
    def do_EOF(self, arg):
        ser.close()
        sys.exit(0)

    def do_loop_reg(self, arg):
        'Test register module'
        send_cmd('r')

    def do_set_reg(self, arg):
        'Send value to register'
        send_cmd("R{}".format(arg))

    def do_display(self, arg):
        'Test display'
        send_cmd('d')



def listen_responses():
    while ser.is_open:
        line = ser.readline().decode('ascii').strip()
        if line:
            print(line)

def send_cmd(cmd):
    ser.write(cmd.encode("ascii"))
    ser.flush()

def identify_device():
    ser.read_all()
    send_cmd('I')
    devid = ser.readline().decode('ascii').strip()
    print (devid)
#    if devid != "MTEST":
#        raise Exception("Device is not a Modules Tester")

if __name__ == "__main__":
    identify_device()

    threading.Thread(target=listen_responses).start()
    TesterClient().cmdloop()
