# cocotb setup
MODULE = test
TOPLEVEL = seven_segment_seconds
VERILOG_SOURCES = seven_segment_seconds.v

include $(shell cocotb-config --makefiles)/Makefile.sim

test: sim
	! grep failure results.xml

gtkwave:
	gtkwave seven_segment_seconds.vcd seven_segment_seconds.gtkw

formal:
	sby -f properties.sby

show_counter: 
	yosys -p "read_verilog seven_segment_seconds.v; proc; opt; show -colors 2 -width -signed seven_segment_seconds"

show_segment: 
	yosys -p "read_verilog seven_segment_seconds.v; proc; opt; show -colors 2 -width -signed seg7"
