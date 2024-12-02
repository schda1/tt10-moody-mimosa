#!/bin/bash

START_DIR=$PWD

# Make sure that you do not start from the project root folder
if [ ! -d "scripts" ] || [ ! -d "test" ]; then
  cd ..
fi

# Run module tests
cd module_test

# Move through all subfolders of the module_test folder
for dir in ./*; do
  echo "Module test for $dir"

  if [ -d "$dir" ]; then
    cd "$dir"
    # Build and execute the test
    make clean && make -B

     # Check if 'failure' is found in the results
    if grep -q failure results.xml; then
      echo -e "\033[31mError: Test failed for $dir\033[0m"
      cd $START_DIR
      return 1
    fi

    cd ..
  fi

done

# Run main design test
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