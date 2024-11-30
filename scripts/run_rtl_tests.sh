#!/bin/bash

if [ ! -d "scripts" ] || [ ! -d "test" ]; then
  cd ..
fi

# Prepare for rtl test
TOP_MODULE=$(python /ttsetup/tt-support-tools/tt_tool.py --print-top-module)
cp -f runs/wokwi/final/pnl/$TOP_MODULE.pnl.v test/gate_level_netlist.v

# Run rtl test
cd test
make -B GATES=yes