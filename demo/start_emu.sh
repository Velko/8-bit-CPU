#!/bin/sh

socat PTY,link=pty0,raw,echo=0 PTY,link=../emulator/vm/pty1,raw,echo=0 &
sleep 0.1
make -C ../emulator/vm/ run &

echo SER_PORT=pty0
echo killall vvp socat
