# Copyright (c) 2016 Technische Universitaet Dresden, Germany
# Chair for VLSI-Design, Diagnostic and Architecture
# Author: Martin Zabel
# All rights reserved.
#$(shell echo gol)

CWD=$(shell pwd)

SIM ?= icarus
TOPLEVEL_LANG ?=verilog

 
VERILOG_SOURCES =$(CWD)/decoder_4_16.v $(CWD)/mux_16_1.v $(CWD)/reg_with_reset_and_write.v $(CWD)/reg_file.v


TOPLEVEL = reg_file
MODULE := reg_file_test
COCOTB_HDL_TIMEUNIT=1us
COCOTB_HDL_TIMEPRECISION=1us

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
