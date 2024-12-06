# Background

The digital design can be built for a FPGA as well. Although the intrinsic 
build process is completely different, usual FPGA tool chains support verilog. For
this project, we build the design for a Artix-7 (xc7a35tftg256-1) FPGA 
by AMD (Xilinx). This is the FPGA chipset placed on the Alchitry Au board. 
This allows us to test the design on actual hardware before ordering the ASIC.

In order to build the bitstream for this FPGA, you need the Vivado toolchain. 
The installation process is described [here](Link). You can either install 
it on your local machine or in the docker container. Note that you have to 
create an account and log in to download the Vivado IDE and tools, and that
the installation requires 50-100 GB. 

Once you've built the bitstream, you need to load it to the FPGA board. For 
alchitry, a loader tool exists and it can be downloaded [here].

In principle, you could design in the Vivado IDE and navigate within the GUI. 
In this project, the build process is managed by a tcl (tool command language)
script and can be fully automated. 
