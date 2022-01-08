#!/bin/sh

VMPATH=$(dirname $0)/../../emulator/vm

socat PTY,link=pty0,raw,echo=0 PTY,link=$VMPATH/pty1,raw,echo=0 &
sleep 0.1
make -C $VMPATH run &
sleep 0.1
