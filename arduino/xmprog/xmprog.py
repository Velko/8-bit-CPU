#!/usr/bin/python3

from os import close
import serial
import time
import subprocess

port = serial.Serial("/dev/ttyUSB0", 115200)
port.setDTR(False)

time.sleep(1)

port.flushInput()
port.setDTR(True)

while True:
    l = port.readline().decode('ascii')
    if l.startswith("XMODEM"):
        print(l)
        break

port.write("sx desas".encode("ascii"))
port.flush()
l = port.readline().decode('ascii')
print (l)

print (port.fileno())

sbp = subprocess.Popen(["/usr/bin/rx", "-c", "mans.bin"], stdin=port.fileno(), stdout=port.fileno(), close_fds=False)

sbp.wait()

print ("Done")