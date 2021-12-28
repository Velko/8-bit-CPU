#!/bin/sh

socat PTY,link=pty0,raw,echo=0 PTY,link=../emulator/vm/pty1,raw,echo=0 &
sleep 0.1
make -C ../emulator/vm/ run &
sleep 0.1
SER_PORT=pty0 python3 -m pytest $@

kill -- -$$
