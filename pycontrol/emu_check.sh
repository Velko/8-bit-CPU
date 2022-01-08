#!/bin/sh

./tools/start_emu.sh

SER_PORT=pty0 python3 -m pytest $@

kill -- -$$
