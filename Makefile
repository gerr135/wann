SOURCES = src/*.ad?

# rule to link the program
gpr:
	gprbuild -P wann.gpr

.PHONY gpr:
