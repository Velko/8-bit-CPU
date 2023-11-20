#!/bin/sh

../tools/start_emu.sh

EMU_SHUTDOWN=1 python3 -m pytest $@

kill -- -$$
