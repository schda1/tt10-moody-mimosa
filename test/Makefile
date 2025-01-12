# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = tt_um_moody_mimosa.v
PROJECT_SOURCES += utility/prescaler.v
PROJECT_SOURCES += utility/dynamic_clock_divider.v
PROJECT_SOURCES += utility/edge_triggered_counter.v
PROJECT_SOURCES += utility/range_classifier.v
PROJECT_SOURCES += utility/saturating_counter.v
PROJECT_SOURCES += utility/static_clock_divider.v
PROJECT_SOURCES += utility/counter_with_pulse.v
PROJECT_SOURCES += utility/resource.v
PROJECT_SOURCES += action/action_regulator.v 
PROJECT_SOURCES += emotion/emotion_regulator.v 
PROJECT_SOURCES += heartbeat/heartbeat_regulator.v 
PROJECT_SOURCES += neurotransmitter/cortisol_regulator.v 
PROJECT_SOURCES += neurotransmitter/cortisol_system.v 
PROJECT_SOURCES += neurotransmitter/dopamine_regulator.v
PROJECT_SOURCES += neurotransmitter/dopamine_system.v
PROJECT_SOURCES += neurotransmitter/norepinephrine_regulator.v
PROJECT_SOURCES += neurotransmitter/norepinephrine_system.v
PROJECT_SOURCES += neurotransmitter/serotonin_regulator.v
PROJECT_SOURCES += neurotransmitter/serotonin_system.v
PROJECT_SOURCES += neurotransmitter/gaba_regulator.v
PROJECT_SOURCES += neurotransmitter/gaba_system.v
PROJECT_SOURCES += neurotransmitter/neurotransmitter_system.v
PROJECT_SOURCES += nourishment/nourishment_regulator.v
PROJECT_SOURCES += nourishment/nourishment_system.v
PROJECT_SOURCES += sleep/sleep_regulator.v
PROJECT_SOURCES += sleep/vital_energy_regulator.v
PROJECT_SOURCES += sleep/vital_energy_system.v
PROJECT_SOURCES += illness/illness_regulator.v
PROJECT_SOURCES += illness/illness_system.v
PROJECT_SOURCES += development_stage/development_stage_regulator.v
PROJECT_SOURCES += development_stage/development_stage_system.v
PROJECT_SOURCES += talk/remember_and_talk.v
PROJECT_SOURCES += talk/speech_planner.v


ifneq ($(GATES),yes)

# RTL simulation:
SIM_BUILD		 = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))
COMPILE_ARGS    += -I$(SRC_DIR)

else

# Gate level simulation:
SIM_BUILD		 = sim_build/gl
COMPILE_ARGS    += -DGL_TEST
COMPILE_ARGS    += -DFUNCTIONAL
COMPILE_ARGS    += -DUSE_POWER_PINS
COMPILE_ARGS    += -DSIM
COMPILE_ARGS    += -DUNIT_DELAY=\#1
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# this gets copied in by the GDS action workflow
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Include the testbench sources:
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tb

# MODULE is the basename of the Python test file
MODULE = test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
