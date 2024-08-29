# make file for compiling and running 16 bit combinational signed multiplier

# compiler
COMPILER = iverilog
# flags
FLAGS = -g2012
# target or output
TARGET = valid_ready_noc
# degin files
DESIGNFILE = src/noc.sv src/packet_generator.sv src/valid_ready_noc_controller.sv/top_level.sv
# test bench file
TESTBENCH = tests/tb.sv
# compile first then run executable
all: $(TARGET)
	./$(TARGET)

# compiling using iverilog
$(TARGET): $(DESIGNFILE) $(TESTBENCH)
	$(COMPILER) $(FLAGS) -o $(TARGET) $(TESTBENCH) $(DESIGNFILE) 
# run the compiled output after compiling
run: $(TARGET)
	./$(TARGET)

# simulation
simulate: $(TARGET)
	gtkwave $(TARGET).vcd
# clean object files and executables
clean: 
	rm -f *.o *.vcd $(TARGET)

.PHONY: all run clean
			


