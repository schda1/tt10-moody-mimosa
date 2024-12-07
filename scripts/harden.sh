#!/bin/bash

# The tt support tools are already installed in the docker container. The
# procedure is thus slightly different than described in the tiny tapeout
# local-hardening guide.

if [ ! -d "scripts" ]; then
  cd ..
fi

# Fetch the tt support tools if needed
if [ ! -d "tt" ]; then
    git clone -b tt10 https://github.com/TinyTapeout/tt-support-tools tt
else
    echo "tt support tools already cloned"
fi

# Harden design with openlane2
python /ttsetup/tt-support-tools/tt_tool.py --create-user-config --openlane2
python /ttsetup/tt-support-tools/tt_tool.py --harden --openlane2
python /ttsetup/tt-support-tools/tt_tool.py --print-warnings --openlane2

# Create overview of gds rendered layout as png
rm -f gds_renderer_preview.svg
rm -f gds_renderer.png
python /ttsetup/tt-support-tools/tt_tool.py --create-png --openlane2

# Copy gate level netlist to test folder
TOP_MODULE=$(python /ttsetup/tt-support-tools/tt_tool.py --print-top-module)
cp runs/wokwi/final/pnl/$TOP_MODULE.pnl.v test/gate_level_netlist.v