Added minimal sleep cycle application
Moody mimosa module will be top
module for ASCI and FPGA. Currently,
it changes between sleeping (low energy)
and being awake (high energy).

Added alchitry wrapper and updated xdc
Possible to implement the moody
mimosa on the Alchitry Au FPGA
target using the IO-pins of the
Alchitry Io board (leds, buttons,
switches). The pins are mapped
in the xdc file and the fpga wrapper
au_moody_mimosa module also
creates a ~1Hz clock that would
otherwise be provided by input
pin 0.
