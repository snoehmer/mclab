
TOS = $(shell ncc -print-tosdir)
#PACKAGE = net.mclab.Ex3Ctrl
APP = ../Ex3
MIG = mig java

# List of message classes to build
MSGS = NetworkMsg.java

INITIAL_TARGETS = $(MSGS)
OTHER_CLEAN = cleanmig

ROOT = $(TOS)/../tools/java/
include $(ROOT)/Makefile.include

NetworkMsg.java:
	$(MIG) -java-classname=NetworkMsg $(APP)/MessageTypes.h NetworkMsg -o $@
	$(JAVAC) $@

cleanmig:
	rm -f $(MSGS)

