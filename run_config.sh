#!/usr/bin/env bash
# first config tcc/
cd tcc
./configure
cd ..
# correct flags for config file
./configure CFLAGS=" -D_GNU_SOURCE -DONE_SOURCE -DLIBTCC_AS_DLL -DUSE_TCL_STUBS -DTCC_TARGET_X86_64 -O2 -I/usr/include/tcl8.6 -I/usr/include/tcl8.6/tcl-private/ -I/usr/include/tcl8.6/tcl-private/generic -I/usr/include/tcl8.6/tcl-private/unix -I/usr/include/tcl8.6"
