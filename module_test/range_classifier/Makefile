# Makefile

# Defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../../src
PROJECT_SOURCES = range_classifier.v

# RTL simulation:
SIM_BUILD		= sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))
COMPILE_ARGS    += -I$(SRC_DIR)

# Include the testbench sources:
VERILOG_SOURCES += $(PWD)/tb_range_classifier.v
TOPLEVEL = tb_range_classifier

# MODULE is the basename of the Python test file
MODULE = test_range_classifier

# Include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
