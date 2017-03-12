# Makefile

# The compiler to be used
CC = g++

PROJECTS := jack ladspa

# Adding PHONY to a target will prevent make from confusing the phony
# target with a file name.  For example, if "clean" is created, "make
# clean" will still be run.
.PHONY: all clean help $(PROJECTS)

# Arguments passed to the compiler: -g causes the compiler to insert
# debugging info into the executable and -Wall turns on all warnings
CFLAGS = -g -Wall -I/usr/lib/faust

# The dynamic libraries that the executable needs to be linked to
LDFLAGS = -L/usr/lib/faust


# The Dependency Rules
# They take the form
# target: dependency1 dependency2...
#        Command(s) to generate target from dependencies
jack: faust_screamer


ladspa: screamer_ladspa.so


faust_screamer: tmp/screamer_jack.cpp
	@echo "Compiling application..."
	@faust2jack "modules/screamer.dsp"
	@mv "modules/screamer" "faust_screamer"
	@echo


screamer_ladspa.so: tmp/screamer_ladspa.cpp
	@echo "Compiling application..."
	@faust2ladspa "modules/screamer.dsp"
	@mv "modules/screamer.so" "screamer_ladspa.so"
	@echo


tmp/screamer_jack.cpp: modules/*.dsp
	@echo
	@echo "=== Jack standalone ==="
	@echo "Creating SVG flow diagram..."
	@rm -f modules/*-svg/*.svg
	@rm -fd modules/*-svg/
	@faust2svg "modules/screamer.dsp"

	@echo "Creating source file..."
	@mkdir -p tmp
	@faust -cn "Screamer" -double "modules/screamer.dsp" \
		-a "jack-qt.cpp" -o "tmp/screamer_jack.cpp" \
		|| (rm -f *.cpp && false)

	@echo "Formatting source file..."
	@astyle --quiet --options=./.astylerc "tmp/screamer_jack.cpp"
	@rm -f tmp/*.cpp.astyle~


tmp/screamer_ladspa.cpp: modules/*.dsp
	@echo
	@echo "=== LADSPA plug-in ==="
	@echo "Creating SVG flow diagram..."
	@rm -f modules/*-svg/*.svg
	@rm -fd modules/*-svg/
	@faust2svg "modules/screamer.dsp"

	@echo "Creating source file..."
	@mkdir -p tmp
	@faust -cn "Screamer" -double "modules/screamer.dsp" \
		-a "ladspa.cpp" -o "tmp/screamer_ladspa.cpp" \
		|| (rm -f *.cpp && false)

	@echo "Formatting source file..."
	@astyle --quiet --options=./.astylerc "tmp/screamer_ladspa.cpp"
	@rm -f tmp/*.cpp.astyle~


clean:
	@rm -f faust_screamer
	@rm -f screamer_ladspa.so

	@rm -f modules/screamer-svg/*.svg
	@rm -fd modules/screamer-svg/

	@rm -f tmp/*.cpp
	@rm -f tmp/*.cpp.astyle~
	@rm -fd tmp/
