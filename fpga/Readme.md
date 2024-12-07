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

# Pinout

We use the same pinout and convention as for the actual ASIC design. The 
pin assignment is described in the following table and follows the pinout
of the Alchitry Io board with plenty of leds, buttons and dip switches on 
board. More information about the pin assignment is contained in the 
schematic of the [Alchitry Au](https://cdn.alchitry.com/docs/alchitry_au_sch.pdf) 
and the [Alchitry Io](https://cdn.alchitry.com/docs/alchitry_io_sch.pdf) board.

## Inputs 

| Name     | Pin  | Connector | Io Board name |
| -------- | ---- | --------- | ------------- |
| ui_in[0] | C6   | B.28      | S1            |
| ui_in[1] | C7   | B.27      | S2            |
| ui_in[2] | A7   | B.23      | S3            |
| ui_in[3] | B7   | B.24      | S4            |
| ui_in[4] | P11  | C.49      | S5            |
| ui_in[5] | C4   | B.40      | DIP1          |
| ui_in[6] | D4   | B.39      | DIP2          |
| ui_in[7] | G4   | B.37      | DIP3          |


## Outputs 

| Name      | Pin  | Connector | Io Board name |
| --------- | ---- | --------- | ------------- |
| uo_out[0] | B6   | B.21      | L1            |
| uo_out[1] | B5   | B.20      | L2            |
| uo_out[2] | A5   | B.18      | L3            |
| uo_out[3] | A4   | B.17      | L4            |
| uo_out[4] | B4   | B.15      | L5            |
| uo_out[5] | A3   | B.14      | L6            |
| uo_out[6] | F4   | B.12      | L7            |
| uo_out[7] | F3   | B.11      | L8            |

## Bidirectional, Input 

| Name      | Pin  | Connector | Io Board name |
| --------- | ---- | --------- | ------------- |
| uio_in[0] | G5   | B.36      | DIP4          |
| uio_in[1] | E5   | B.34      | DIP5          |
| uio_in[2] | F5   | B.33      | DIP6          |
| uio_in[3] | D5   | B.31      | DIP7          |
| uio_in[4] | D6   | B.30      | DIP8          |
| uio_in[5] | N6   | A.28      | DIP9          |
| uio_in[6] | M6   | A.27      | DIP10         |
| uio_in[7] | B1   | B.49      | DIP11         |

## Bidirectional, Output 

| Name       | Pin  | Connector | Io Board name |
| ---------- | ---- | --------- | ------------- |
| uio_out[0] | F2   | B.9       | L9            |
| uio_out[1] | E1   | B.8       | L10           |
| uio_out[2] | B2   | B.6       | L11           |
| uio_out[3] | A2   | B.5       | L12           |
| uio_out[4] | E2   | B.3       | L13           |
| uio_out[5] | D1   | B.2       | L14           |
| uio_out[6] | K5   | A.24      | L15           |
| uio_out[7] | E6   | A.23      | L16           |

