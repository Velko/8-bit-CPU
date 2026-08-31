#!/bin/sh

killall -9 vvp turbo-vm || true

VMPATH=$(dirname $0)/../turbo
cd $VMPATH
cargo build
cargo run &
sleep 0.1
