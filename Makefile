TARGET = run_customNN
SOURCES = src/*.ad?

# rule to link the program
customNN: $(SOURCES)
	gprbuild -P customNN.gpr
