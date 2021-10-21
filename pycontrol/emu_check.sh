#!/bin/sh

socat PTY,link=pty0,raw,echo=0 PTY,link=pty1,raw,echo=0 &
sleep 0.1
../emulator/vm/cpu-server &
sleep 0.1
SER_PORT=pty0 python3 -m pytest $@

kill -- -$$
