SOURCES = src/*.ad?

# rule to link the program
gpr:
	gprbuild -P wann.gpr

clean:
	rm -f obj/*/* bin/*

.PHONY gpr, clean:
