#!/bin/sh

killall -9 vvp turbo-vm-server || true

VMPATH=$(dirname $0)/../turbo
cd $VMPATH
cargo build
cargo run --bin turbo-vm-server &
sleep 0.1
