set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR NO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 1 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]

# 100 MHz base clock
create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]

set_property PACKAGE_PIN N14 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property PACKAGE_PIN P6 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

set_property PACKAGE_PIN K13 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN K12 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN L14 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN L13 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]

set_property PACKAGE_PIN M16 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]

set_property PACKAGE_PIN M14 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]

set_property PACKAGE_PIN M12 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]

set_property PACKAGE_PIN N16 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]

# Output port, uo_out
set_property PACKAGE_PIN B6 [get_ports {uo_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uo_out[0]}]

set_property PACKAGE_PIN B5 [get_ports {uo_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uo_out[1]}]

set_property PACKAGE_PIN A5 [get_ports {uo_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uo_out[2]}]

set_property PACKAGE_PIN A4 [get_ports {uo_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uo_out[3]}]

set_property PACKAGE_PIN B4 [get_ports {uo_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uo_out[4]}]

set_property PACKAGE_PIN A3 [get_ports {uo_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uo_out[5]}]

set_property PACKAGE_PIN F4 [get_ports {uo_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uo_out[6]}]

set_property PACKAGE_PIN F3 [get_ports {uo_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uo_out[7]}]

# Input port, ui_in
set_property PACKAGE_PIN C6 [get_ports {ui_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ui_in[0]}]

set_property PACKAGE_PIN C7 [get_ports {ui_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ui_in[1]}]

set_property PACKAGE_PIN A7 [get_ports {ui_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ui_in[2]}]

set_property PACKAGE_PIN B7 [get_ports {ui_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ui_in[3]}]

set_property PACKAGE_PIN P11 [get_ports {ui_in[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ui_in[4]}]

set_property PACKAGE_PIN C4 [get_ports {ui_in[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ui_in[5]}]

set_property PACKAGE_PIN D4 [get_ports {ui_in[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ui_in[6]}]

set_property PACKAGE_PIN G4 [get_ports {ui_in[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ui_in[7]}]

# Bidirectional port emulation, uio_in
set_property PACKAGE_PIN G5 [get_ports {uio_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_in[0]}]

set_property PACKAGE_PIN E5 [get_ports {uio_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_in[1]}]

set_property PACKAGE_PIN F5 [get_ports {uio_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_in[2]}]

set_property PACKAGE_PIN D5 [get_ports {uio_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_in[3]}]

set_property PACKAGE_PIN D6 [get_ports {uio_in[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_in[4]}]

set_property PACKAGE_PIN N6 [get_ports {uio_in[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_in[5]}]

set_property PACKAGE_PIN M6 [get_ports {uio_in[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_in[6]}]

set_property PACKAGE_PIN B1 [get_ports {uio_in[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_in[7]}]

# Bidirectional port emulation, uio_out
set_property PACKAGE_PIN F2 [get_ports {uio_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_out[0]}]

set_property PACKAGE_PIN E1 [get_ports {uio_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_out[1]}]

set_property PACKAGE_PIN B2 [get_ports {uio_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_out[2]}]

set_property PACKAGE_PIN A2 [get_ports {uio_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_out[3]}]

set_property PACKAGE_PIN E2 [get_ports {uio_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_out[4]}]

set_property PACKAGE_PIN D1 [get_ports {uio_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_out[5]}]

set_property PACKAGE_PIN K5 [get_ports {uio_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_out[6]}]

set_property PACKAGE_PIN E6 [get_ports {uio_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {uio_out[7]}]

# serial names are flipped in the schematic (named for the FTDI chip)
set_property PACKAGE_PIN P16 [get_ports {usb_tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {usb_tx}]

set_property PACKAGE_PIN P15 [get_ports {usb_rx}]
set_property IOSTANDARD LVCMOS33 [get_ports {usb_rx}]