#!/bin/bash

# Make sure that you do not start from the project root folder
if [ ! -d "scripts" ] || [ ! -d "test" ]; then
  cd ..
fi

PRJ=$(pwd)
CPPUTEST=$PRJ/misc/mimosa_logger/cpputest

# Install python dependencies
pip install -r /workspaces/tt10-moody-mimosa/test/requirements.txt
pip install -r /workspaces/tt10-moody-mimosa/simulation/requirements.txt

# Initialize git submodules (ST Drivers, cpputest)
git submodule init
git submodule update --init --recursive

# Slight modification of the cpputest configure script
source scripts/add_ranlib_to_cpputest_configure.sh

# Build cpputest
cd misc/mimosa_logger/cpputest
mkdir cpputest_build
cd cpputest_build
autoreconf .. -i
../configure
make

# Copy built libraries
mkdir -p $CPPUTEST/lib
cp -f $CPPUTEST/cpputest_build/lib/libCppUTest.a $CPPUTEST/lib/libCppUTest.a
cp -f $CPPUTEST/cpputest_build/lib/libCppUTestExt.a $CPPUTEST/lib/libCppUTestExt.a

# Return to the project root folder
cd $PRJ