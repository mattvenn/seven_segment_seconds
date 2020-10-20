# cocotb setup
MODULE = test
TOPLEVEL = seven_segment_seconds
VERILOG_SOURCES = seven_segment_seconds.v

include $(shell cocotb-config --makefiles)/Makefile.sim

gtkwave:
	gtkwave seven_segment_seconds.vcd seven_segment_seconds.gtkw
