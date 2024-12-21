#! /bin/sh

pip install -r /workspaces/tt10-moody-mimosa/test/requirements.txt
pip install -r /workspaces/tt10-moody-mimosa/simulation/requirements.txt
git submodule init
git submodule update --init --recursive
