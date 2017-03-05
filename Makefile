# Adding PHONY to a target will prevent make from confusing the phony
# target with a file name.  For example, if "clean" is created, "make
# clean" will still be run.
.PHONY: all clean help $(PROJECTS)

PROJECTS := jack ladspa

all:  $(PROJECTS)

jack:
	@${MAKE} --no-print-directory -C . -f screamer.make jack

ladspa:
	@${MAKE} --no-print-directory -C . -f screamer.make ladspa

clean:
	@${MAKE} --no-print-directory -C . -f screamer.make clean
