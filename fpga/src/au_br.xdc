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

# Port A0 (Outputs)
set_property PACKAGE_PIN T8 [get_ports {port_a0[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a0[0]}]

set_property PACKAGE_PIN T5 [get_ports {port_a0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a0[1]}]

set_property PACKAGE_PIN R8 [get_ports {port_a0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a0[2]}]

set_property PACKAGE_PIN L2 [get_ports {port_a0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a0[3]}]

set_property PACKAGE_PIN J1 [get_ports {port_a0[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a0[4]}]

set_property PACKAGE_PIN H1 [get_ports {port_a0[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a0[5]}]

set_property PACKAGE_PIN G1 [get_ports {port_a0[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a0[6]}]

set_property PACKAGE_PIN K5 [get_ports {port_a0[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a0[7]}]

# Port A1 (Inputs)
set_property PACKAGE_PIN T7 [get_ports {port_a1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a1[0]}]

set_property PACKAGE_PIN R5 [get_ports {port_a1[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a1[1]}]

set_property PACKAGE_PIN P8 [get_ports {port_a1[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a1[2]}]

set_property PACKAGE_PIN L3 [get_ports {port_a1[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a1[3]}]

set_property PACKAGE_PIN K1 [get_ports {port_a1[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a1[4]}]

set_property PACKAGE_PIN H2 [get_ports {port_a1[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a1[5]}]

set_property PACKAGE_PIN G2 [get_ports {port_a1[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a1[6]}]

set_property PACKAGE_PIN E6 [get_ports {port_a1[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a1[7]}]

# Port A2 (bidirectional pins)
set_property PACKAGE_PIN T10 [get_ports {port_a2[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a2[0]}]

set_property PACKAGE_PIN R6 [get_ports {port_a2[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a2[1]}]

set_property PACKAGE_PIN P9 [get_ports {port_a2[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a2[2]}]

set_property PACKAGE_PIN K2 [get_ports {port_a2[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a2[3]}]

set_property PACKAGE_PIN J4 [get_ports {port_a2[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a2[4]}]

set_property PACKAGE_PIN H3 [get_ports {port_a2[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a2[5]}]

set_property PACKAGE_PIN H4 [get_ports {port_a2[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a2[6]}]

set_property PACKAGE_PIN N6 [get_ports {port_a2[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {port_a2[7]}]

# serial names are flipped in the schematic (named for the FTDI chip)
set_property PACKAGE_PIN P16 [get_ports {usb_tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {usb_tx}]

set_property PACKAGE_PIN P15 [get_ports {usb_rx}]
set_property IOSTANDARD LVCMOS33 [get_ports {usb_rx}]