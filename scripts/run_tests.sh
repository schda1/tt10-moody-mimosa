#!/bin/bash

if [ ! -d "scripts" ] || [ ! -d "test" ]; then
  cd ..
fi

# Run rtl test
cd test

rm -rf sim_build
rm -f tb.vcd
make -B

cd ..