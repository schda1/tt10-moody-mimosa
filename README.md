![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Project description


# Content

For this project, I wanted to learn how to design a simple digital ASIC and for that
matter, to learn a HDL-language. However, I also wanted to figure out how to find solutions
for common problems. How do you test your components or your entire design? How can I run
the design on my Alchitry Au FPGA board and how can I build from the command line? Can you 
simulate the HDL sources and interactively play with it, e.g. with a simple python GUI?



| Folder      | Content                                                                      | 
| ----------- | ---------------------------------------------------------------------------- |
| src         | Verilog sources for the ASIC development                                     |
| test        | Test of the entire moody_mimosa module using python and cocotb               |
| module_test | Unit tests of all submodules used by moody_mimosa, using python and cocotb   |
| fpga        | Wrapper, xdc- and tcl-file used to build for Alchitry Au FPGA board          |
| scripts     | Scripts to e.g. build design, run tests, harden asic                         | 
| simulation  | Interactive pyverilator simulation (GUI) to play with the mimosa design      |  
| misc        | Side-projects, e.g. optimizing truth tables with pyeda and espresso logic    |  

