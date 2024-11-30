#!/bin/bash

START_DIR=$PWD

if [ ! -d "scripts" ] || [ ! -d "test" ]; then
  cd ..
fi

# Run module tests
cd module_test

for dir in ./*; do
  echo "Module test for $dir"

  if [ -d "$dir" ]; then
    cd "$dir"
    make clean && make -B
    ! grep failure results.xml
    cd ..
  fi

done

# Run main test
cd ../test
make clean && make -B
! grep failure results.xml

# Run main RTL test
make clean && make -B GATES=yes
! grep failure results.xml

# Comment
echo -e "\e[32mAll tests run successfully!\e[0m"

# Move back to initial directory
cd $START_DIR