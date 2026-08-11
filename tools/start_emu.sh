#!/bin/sh

killall -9 vvp turbo-vm || true

VMPATH=$(dirname $0)/../emulator/vm

#socat /dev/ttyUSB0,raw,echo=0 udp-listen:8888,reuseaddr
make -C $VMPATH run &
sleep 0.1
