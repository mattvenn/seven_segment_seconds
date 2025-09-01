# cocotb setup
MODULE = test
TOPLEVEL = seven_segment_seconds
VERILOG_SOURCES = seven_segment_seconds.v
export COCOTB_REDUCED_LOG_FMT=1

include $(shell cocotb-config --makefiles)/Makefile.sim

gtkwave:
	gtkwave seven_segment_seconds.vcd seven_segment_seconds.gtkw

formal:
	sby -f properties.sby

show_counter: 
	yosys -p "read_verilog seven_segment_seconds.v; proc; opt; show -colors 2 -width -signed seven_segment_seconds"

show_segment: 
	yosys -p "read_verilog seven_segment_seconds.v; proc -norom; opt; show -colors 2 -width -signed seg7"

synth:
	rm -rf runs
	PDK_ROOT=/foss/pdks PDK=sky130A PDKPATH=/foss/pdks/sky130A STD_CELL_LIBRARY=sky130_fd_sc_hd \
		 librelane --manual-pdk config.json --run-tag 7seg --to Yosys.Synthesis

show_hierarchy:
	xdot runs/synth/06-yosys-synthesis/hierarchy.dot

show_cells:
	xdot runs/synth/06-yosys-synthesis/primitive_techmap.dot
