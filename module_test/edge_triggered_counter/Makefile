# Makefile

# Defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../../src
PROJECT_SOURCES = edge_triggered_counter.v

# RTL simulation:
SIM_BUILD		 = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))
COMPILE_ARGS    += -I$(SRC_DIR)

# Include the testbench sources:
VERILOG_SOURCES += $(PWD)/tb_edge_triggered_counter.v
TOPLEVEL = tb_edge_triggered_counter

# MODULE is the basename of the Python test file
MODULE = test_edge_triggered_counter

# Include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
