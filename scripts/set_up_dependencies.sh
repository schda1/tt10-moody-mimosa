#!/bin/bash

# Make sure that you do not start from the project root folder
if [ ! -d "scripts" ] || [ ! -d "test" ]; then
  cd ..
fi

PRJ=$(pwd)

# Install python dependencies
pip install -r /workspaces/tt10-moody-mimosa/test/requirements.txt
pip install -r /workspaces/tt10-moody-mimosa/simulation/requirements.txt
