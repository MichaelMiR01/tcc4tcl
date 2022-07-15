tcc4tcl v. 0.40
===============

tcc4tcl (Tiny C Compiler for Tcl) is a Tcl extension that provides an interface 
to [TinyCC](https://repo.or.cz/w/tinycc.git).

It is a fork of tcctcl by Mark Janssen.

It is licensed under the terms of the LGPL v2.1 (or later).

[Original home page.](https://chiselapp.com/user/rkeene/repository/tcc4tcl/home)

[Github mirror of original project.](https://github.com/rkeene/tcc4tcl)

[Tclers' Wiki page.](https://wiki.tcl-lang.org/page/tcc4tcl)

------------------------------

The tcc4tcl package allows access from Tcl to TinyCC, a compact, self-contained and portable C preprocessor, compiler, linker and assembler.  As such, it can be an excellent interactive tool for quickly and easily providing C-coded speed enhancements for performance-critical sections of a Tcl program, as well as generally for learning C and prototyping C code.

On top of that, tcc4tcl adds features that make it easy to create binary package extensions that efficiently use the Tcl C API and stubs interface feature for adding commands to a Tcl interpreter and managing libraries.

## Quickstart:

On Unix, compile the package using the standard commands:

    $ configure; make
    
On Windows, run the script **win32/build-tcc4tcl-win32.bat**

Once the package is built and the build directory is added to the Tcl package 
path list, you can test with the following commands in a Tcl shell:

    % package require tcc4tcl
    0.40
    % ::tcc4tcl::cproc test {int i} int { return (i+42); }
    TCC_COMPILE_OK
    % test 1
    43

## Features

Tcc4tcl can be used as a "just in time" compiler, compiling C code embedded in 
a Tcl script on the fly as the script is executing.  The TinyCC compiler is 
designed to be so fast that the compilation time for modest functions will be 
small compared to the total execution time of a typical program.

C functions once compiled and wrapped by tcc4tcl can then be executed as 
standard Tcl commands in a running interpreter or program.

Tcc4tcl can also be used to save compiled C code in a Tcl package extension in 
the form of a shared library object file.  Such a file can be loaded later into 
a newly-started Tcl interpreter using the standard Tcl **load** command, thus 
saving the need to compile the code each time it is needed.

Standalone executable programs can also be compiled and saved to a binary 
executable file.

In addition to writing and compiling new Tcl commands in C, tcc4tcl can be used 
to wrap existing compiled C functions from a shared or static library file, and 
call the wrapped functions as Tcl commands.  For example, assuming there exists 
a shared library **/usr/lib/x86_64-linux-gnu/libcurl.so**, the following can be 
done to make the [curl](https://curl.se/) API command "curl_version" callable from Tcl:

    % set handle [tcc4tcl::new]
    ::tcc4tcl::tcc_1
    % $handle cwrap curl_version {} vstring
    curl_version {tcl_curl_version vstring {}}
    % $handle add_library_path /usr/lib/x86_64-linux-gnu
    /usr/lib/x86_64-linux-gnu
    % $handle add_library curl
    curl
    % $handle go
    TCC_COMPILE_OK
    % curl_version
    libcurl/7.47.0 OpenSSL/1.0.2g zlib/1.2.8 libidn/1.32 librtmp/2.3
    
Tcc4tcl can be used to embed Tcl code into a C function and thus make the Tcl 
code callable from within C code.  Thus you can for example create a Tcl 
package that combines Tcl and C within a single shared library package 
extension file.

The tcc4tcl package includes the file **tcc4critcl.tcl**, which includes shim 
procedures that map a subset of 
[CriTcl](https://github.com/andreas-kupries/critcl) commands to tcc4tcl 
equivalents.  Thus some projects that have used CriTcl in the past to 
incorporate C code into Tcl programs may be able to use tcc4tcl as an 
alternative.  Example scripts for compiling 
[tcllibc](https://wiki.tcl-lang.org/page/tcllibc) are included.

## Enhancements from previous release

The tcc4tcl package has been updated to use the latest official release of 
TinyCC, 0.9.27, replacing version 0.9.26.

Improvements have been made to make tcc4tcl compile and run correctly on the 
Windows platform, and to incorporate the Tk C API properly.

Header files tclInt.h and tclIntdecls.h and their dependencies are included and 
tcc4tcl will populate not only tclStubsPtr, but tclIntStubsPtr also.
This is neccessary to run Tom Pointdexters [Tcl Static 
Prime](https://github.com/tpoindex/tsp) transpiler, since it uses 
Tcl_PushCallframe/Tcl_PopCallframe, which are Tcl internals.


## Repository notes

[This repository](https://github.com/tcllab/tcc4tcl) is a fork made in an 
effort to combine multiple independent contributions to the project and to 
upgrade the [TinyCC compiler](https://github.com/TinyCC/tinycc) used (0.9.26, 
released 2013) to the latest release (0.9.27, released 2017)

All independent contributions and the upgraded TinyCC 0.9.27 code have been 
merged to the "master" branch.  Anyone interested in giving this package a try 
is encouraged to check out or download this branch.

This repository was forked from [cyanolgivie's 
fork](https://github.com/cyanogilvie/tcc4tcl) of rkeene's repository.

A branch called "tcllab" was created from the commit representing the last 
official release (tcc4tcl 0.30) made by rkeene.

Another branch called "upgrade_tcc_0_9_27" was created from the last official 
release commit, for the purpose of carrying out the upgrade to tinycc 0.9.27.

The "upgrade_tcc_0_9_27" branch has been merged into the "master" branch, which 
is now the main development branch.  Experimental enhancements will continue to 
be made on the "upgrade_tcc_0_9_27" branch and will be merged into the master 
branch as they are ready.

## Contributors

[Michael Richter](https://github.com/MichaelMiR01) originated the upgrade 
effort and is the chief author of the current improvements.

[Steve Huntley](https://wiki.tcl-lang.org/page/Steve+Huntley) provided assistance and advice.
