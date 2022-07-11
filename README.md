tcc4tcl
=======

tcc4tcl (Tiny C Compiler for Tcl) is a Tcl extension that provides an interface 
to TCC.

It is a fork of tcctcl by Mark Janssen.

It is licensed under the terms of the LGPL v2.1 (or later).

[Original home page.](https://chiselapp.com/user/rkeene/repository/tcc4tcl/home)

[Github mirror of original project.](https://github.com/rkeene/tcc4tcl)

[Tclers' Wiki page.](https://wiki.tcl-lang.org/page/tcc4tcl)

------------------------------

[This repository](https://github.com/tcllab/tcc4tcl) is a fork made in an 
effort to combine multiple independent contributions to the project and to 
upgrade the [tinycc compiler](https://github.com/TinyCC/tinycc) used (0.9.26, 
released 2013) to the latest release (0.9.27, released 2017)

This repository was forked from [cyanolgivie's 
fork](https://github.com/cyanogilvie/tcc4tcl) of rkeene's repository.

A branch called "tcllab" was created from the commit representing the last 
official release (tcc4tcl 0.30) made by rkeene.

To the "tcllab" branch have been added enhancements contributed by 
[MichaelMiR01](https://github.com/MichaelMiR01/tcc4tcl).

Another branch called "upgrade_tcc_0_9_27" was created from the last official 
release commit to carry out the upgrade to tinycc 0.9.27.

The plan is to merge all enhancements committed by rkeene, cyanogilvie, 
MichaelMiR01 and tcllab into the "tcllab" branch,  which will then be merged 
into the "master" branch as a new release.

Update 22-07-03: 
Building and installing:
Actually the automated build process works for the 0.9.27 branch, you can use./configure;make to get the necessary files (pkgIndex, tcc4cl.so, tcc4tcl.tcl tcc4critcl.tcl)
To install you have to copy these into a proper location for a tcl-package, so tcl can package require tcc4tcl.
To do anything useful, tcc will also need the subdirs include/lib/tcc and (maybe win32 if you're doing windows) copied into the package dir.

Compiling under windows is still done by hand, I try to give some hints on this, meanwhile take a look at the makefile for the necessary symbols (-DUSE_TCL_STUBS, -DONE_SOURCE, -DHAVE_TCL_H,-D_WIN32) and files to compile. 
Don't forget to link to the necessary libtclstub86elf (for win32) or libtclstubs86_64 (for linux64). Also the libtcc1.a file (tcc pendant to libgcc) generated in the buildprocess will be needed to run tcc4tcl successfully, but there are working copies included in the lib directory also.

Additions/Patches: 
I patched tcc4tcl.tcl to make tk functional also, tested under win32 and linux64, so you can now use tk c-api also.
Furthermore I included tclInt.h and tclIntdecls.h and its dependencies and tcc4tcl will make populate not only tclStubsPtr, but tclIntStubsPtr also.
This is neccessary to run Tom Pointdexters TSP transpiler, since it uses Tcl_PushCallframe/Tcl_PopCallframe, which are Tcl internals.
