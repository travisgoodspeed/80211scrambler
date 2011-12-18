
#clear; iverilog scrambler_tb.v && ./a.out; gtkwave scrambler_tb.vcd

VCC=iverilog
VFLAGS=
LDFLAGS=
SOURCES=scrambler_tb.v descrambler_tb.v synch_tb.v beacon_tb.v unscrambler_tb.v scrambledpip_tb.v
OBJECTS=$(SOURCES:.v=.exe)
SIMS=$(SOURCES:.v=.txt)
EXECUTABLE=hello

all: $(OBJECTS) $(SIMS)

%.exe: %.v $(DEPS)
	$(VCC) -o $@ $< $(VFLAGS)
%.txt: %.exe
	vvp $< | tee $@ | head -n 40

clean:
	rm -f $(OBJECTS)
