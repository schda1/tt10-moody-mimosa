# FPGA Target

In order to test the digital design on hardware prior to ordering the asic,
it can be built for a FPGA board as well. Although implementing a design is
fundamentally different for a FPGA and an ASIC, the FPGA tool-chains
support verilog and all the magic happens behind the scene.

For this project, we build the design for an Artix-7 (xc7a35tftg256-1) FPGA
by AMD (Xilinx). This is the FPGA chipset placed on the [Alchitry Au board](https://alchitry.com/boards/au/), as shown below.

![Alchitry Au FPGA board](https://cdn.sparkfun.com/assets/parts/1/5/4/0/1/16527-Alchitry_Au_FPGA_Development_Board__Xilinx_Artix_7_-02.jpg)

In order to build the bitstream for this FPGA, you need the Vivado toolchain.
The installation process is described [here](Link). With some tweaks, you could
add the vivado build environment to the docker container. However, you have
to create an AMD account and download the Vivado IDE and tools from their
website. The installation is heavy (50-100GB). You also need a loader to actually load the created bitstream either into the RAM or FLASH. Alchitry
provides a [Alchitry loader](https://alchitry.com/news/alchitry-loader-v2/)
to simplify your life.

![Alchitry Au FPGA board](https://cdn.alchitry.com/labs-v2/loader-alpha.png)

In principle, you could develop the fpg application in the Vivado IDE
and navigate within the GUI. In this project, the build process is
managed by a tcl (tool command language) script and can be fully automated.
By creating a dedicated docker container with all the vivado tools
installed, you could thus create the bitstream with a Github Action.
For larger designs, this would make your life much easier as synthesis
may take a very long time.

From the host machine or docker container, where your vivado tools
are installed, run the following command:

```
vivado -mode batch -source alchitry_build.tcl
```



# Pinout

We use the same pinout and convention as for the actual ASIC design. The
pin assignment is described in the following table and follows the pinout
of the Alchitry Io board with plenty of leds, buttons and dip switches on
board. More information about the pin assignment is contained in the
schematic of the [Alchitry Au](https://cdn.alchitry.com/docs/alchitry_au_sch.pdf)
and the [Alchitry Io](https://cdn.alchitry.com/docs/alchitry_io_sch.pdf) board.

Detail: Since we do not need bidirectional pins in the moody mimosa project,
the output-enabled signals are not implemented.

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
| uio_out[6] | E6   | A.24      | L15           |
| uio_out[7] | K5   | A.23      | L16           |

## Debug, Output

| Name       | Pin  | Connector | Io Board name |
| ---------- | ---- | --------- | ------------- |
| uio_out[0] | G2   | A.21      | L17           |
| uio_out[1] | G1   | A.20      | L18           |
| uio_out[2] | H2   | A.18      | L19           |
| uio_out[3] | H1   | A.17      | L20           |
| uio_out[4] | K1   | A.15      | L21           |
| uio_out[5] | J1   | A.14      | L22           |
| uio_out[6] | L3   | A.12      | L23           |
| uio_out[7] | L2   | A.11      | L24           |
