#Set this to @ to keep the makefile quiet
SILENCE = @

#---- Outputs ----#
COMPONENT_NAME = mimosa_logger
CPPUTEST_HOME = ../cpputest

#--- Inputs ----#
PROJECT_HOME_DIR = .
ifeq "$(CPPUTEST_HOME)" ""
$(error The environment variable CPPUTEST_HOME is not set. \
Set it to where cpputest is installed)
endif

# --- SRC_FILES and SRC_DIRS ---
# Production code files are compiled and put into
# a library to link with the test runner.
SRC_FILES += ../App/Src/message_parser.c
SRC_FILES += ../App/Src/pwm_handler.c
# SRC_DIRS += example-platform

# --- TEST_SRC_FILES and TEST_SRC_DIRS ---
# Test files are always included in the build.
# TEST_SRC_FILES += 
TEST_SRC_DIRS += ../tests

# --- MOCKS_SRC_DIRS ---
# MOCKS_SRC_DIRS specifies a directories where you can put your
# mocks, stubs and fakes. 
MOCKS_SRC_DIRS +=../tests/mock

# Turn on CppUMock
CPPUTEST_USE_EXTENSIONS = Y

# INCLUDE_DIRS are searched in order after the included file's containing directory
INCLUDE_DIRS += $(CPPUTEST_HOME)/include
INCLUDE_DIRS += $(CPPUTEST_HOME)/include/Platforms/Gcc
INCLUDE_DIRS += ../App/Inc
INCLUDE_DIRS += ../tests

# --- CPPUTEST_OBJS_DIR ---
# CPPUTEST_OBJS_DIR lets you control where the
# build artifact (.o and .d) files are stored.
CPPUTEST_OBJS_DIR = build/test-obj
CPPUTEST_LIB_DIR = build/test-lib

CPPUTEST_WARNINGFLAGS += -Wall
CPPUTEST_WARNINGFLAGS += -Werror
CPPUTEST_WARNINGFLAGS += -Wfatal-errors
CPPUTEST_WARNINGFLAGS += -Wswitch-default
CPPUTEST_WARNINGFLAGS += -Wno-format-nonliteral
CPPUTEST_WARNINGFLAGS += -Wno-sign-conversion
CPPUTEST_WARNINGFLAGS += -Wno-pedantic
CPPUTEST_WARNINGFLAGS += -Wno-shadow
CPPUTEST_WARNINGFLAGS += -Wno-missing-field-initializers
CPPUTEST_WARNINGFLAGS += -Wno-unused-parameter
CPPUTEST_CFLAGS += -pedantic
CPPUTEST_CFLAGS += -Wno-missing-prototypes
CPPUTEST_CFLAGS += -Wno-strict-prototypes
CPPUTEST_CFLAGS += -DUTEST
CPPUTEST_CXXFLAGS += -Wno-c++14-compat
CPPUTEST_CXXFLAGS += --std=c++11
CPPUTEST_CXXFLAGS += -Wno-c++98-compat-pedantic
CPPUTEST_CXXFLAGS += -Wno-c++98-compat
CPPUTEST_CXXFLAGS += -DUTEST

# Coloroze output
CPPUTEST_EXE_FLAGS += -c

# --- LD_LIBRARIES -- Additional needed libraries can be added here.
# commented out example specifies math library
#LD_LIBRARIES += -lm

include $(CPPUTEST_HOME)/build/MakefileWorker.mk