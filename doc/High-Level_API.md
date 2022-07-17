High-Level API Manual Page
==========================

    package require tcc4tcl

## tcc4tcl::new
Creates a new TCC interpreter instance.

Synopsis:

    tcc4tcl::new ?<outputFile> ?<packageNameAndVersionsAsAList>??
    
Returns an opaque handle which is also a Tcl command to operate on.

If neither `<outputFile>` nor `<packageNameAndVersionsAsAList>` are specified, 
compilation (which happens when [$handle go] is called) is performed to memory.

If only `<outputFile>` is specified then an executable is written to the file 
named.

If `<packageNameAndVersionsAsAList>` is also specified then a Tcl extension is 
written as a shared library (shared object, dynamic library, dynamic linking 
library) to the file named. The format is a 2 or 3 element list: the first is 
the name of the package, the second is the package version number, the third if 
it exists is the minimum acceptable Tcl version number passed to the Tcl stubs 
library initialization function (defaults to TCL_VERSION macro in header file 
tcl.h).

Examples:

1. Create a handle that will compile to memory:

    set handle [tcc4tcl::new]

2. Create a handle that will compile to an executable named "myProgram":

    set handle [tcc4tcl::new myProgram]

3. Create a handle that will compile to a shared library named "myPackage" with 
the package name "myPackage" and version "1.0":

    set handle [tcc4tcl::new myPackage "myPackage 1.0"]
    
The subcommands of the handle are:

- cproc
- cwrap
- ccommand
- proc
- ccode
- code
- linktclcommand
- tk
- add_include_path
- add_library_path
- add_library
- add_file
- process_command_line
- delete
- go

The first five subcommands write C code to a text buffer.  These subcommands 
can be called multiple times in any order to build the code base to be compiled 
in the buffer.  The "code" subcommand can be used at any time before 
compilation to view the buffer's current contents.

The remaining subcommands manage the configuration and compilation process.

### $handle cproc
Create a C function with the given arguments and code, and a Tcl procedure that 
calls the C function.

Synopsis:

    $handle cproc <procName> <argList> <returnType> ?<code>?
    
- `<procName>` is the name of the Tcl procedure to create
- `<argList>` is a list of arguments and their types for the C function;
    The list is in the format of: type1 name1 type2 name2 ... typeN nameN
    The supported types are:
        - Tcl_Interp*: Must be first argument, will be the interpreter and the 
                       user will not need to pass this parameter
        - int
        - long
        - float
        - double
        - char*
        - Tcl_Obj*: Passes in the Tcl object unchanged
        - Tcl_WideInt
        - void*
- `<returnType>` is the return type for the C function
    The supported types are:
        - void: No return value
        - ok: Return TCL_OK or TCL_ERROR
        - int
        - long
        - float
        - double
        - Tcl_WideInt
        - char*: TCL_STATIC string (immutable from C -- use this for constants)
        - string, dstring: return a (char*) that is a TCL_DYNAMIC string
                           (allocated from Tcl_Alloc, will be managed by Tcl)
        - vstring: return a (char*) that is a TCL_VOLATILE string
                   (mutable from C, will be copied by Tcl -- use this for local 
                   variables)
        - default: Tcl_Obj*, a Tcl Object
- `<code>` is the C code that composes the function.
    If the `<code>` argument is omitted it is assumed there is already an 
    implementation (with the name specified as `<procName>`, minus any 
namespace 
    declarations) and this just creates the wrapper and Tcl command.

### $handle cwrap
Create a Tcl procedure that wraps an existing C function. This only differs 
from the cproc subcommand with no `<code>` argument in that it creates a 
prototype before referencing the function.

Synopsis:

    $handle cwrap <procName> <argList> <returnType>
    
### $handle ccommand
Create a C function that will act as a custom Tcl procedure. The C function 
will automatically be defined with the typed arguments required by the Tcl API 
for C functions that can be called as procedures within an interpreter.

Synopsis:

    $handle ccommand <tclCommandName> <argList> <body>

- `<tclCommandName>` is the name of the C function and of the Tcl procedure that
    will call it.
- `<argList>` is the list of variable names to be used in the function's
    argument list.  These are named in the prototype Tcl_ObjCmdProc as:
    {clientData interp objc objv}.  The list provided must be in the same order.
- `<body>` is the C code that composes the function.

### $handle proc
Embed Tcl code into a C function so that the Tcl code is executed when the 
function is called.

Synopsis:

    $handle proc <CName> <argList> <returnType> <body> ?--error <returnErrVal>?
    
- `<CName>` is the name of the C function to be created
- `<argList>` is a list of arguments and their types for the C function;
    The list is in the format of: type1 name1 type2 name2 ... typeN nameN
    The supported types are:
        - Tcl_Interp*: If not included a new Tcl Interpreter will be created
                       each time the function is called
        - int
        - long
        - float
        - double
        - char*
        - Tcl_Obj*
        - Tcl_WideInt
- `<returnType>` is the return type for the C function
    The supported types are:
        - void: No return value
        - ok: Return TCL_OK or TCL_ERROR
        - int
        - long
        - Tcl_WideInt
        - float
        - double
        - char*
        - Tcl_Obj*
- `<body>` is the Tcl code to be embedded
- --error `<returnErrVal>` : the specified value will be inserted as the
        argument of a call to the C **return** function, in case evaluation of
        the Tcl code results in an error.

### $handle ccode
Add arbitrary C code to the handle's text buffer to be compiled.

Synopsis:

    $handle ccode <code>
    
### $handle code
Return contents of text buffer containing code that will be compiled when the 
**go** subcommand is called.

Synopsis:

    $handle code
    
### $handle linktclcommand
Create a Tcl procedure that calls an existing C function.  In the case of 
compiling to memory, this subcommand uses the **Tcl_CreateObjCommand** Tcl API 
function to link the C function to a Tcl procedure accessible in the 
interpreter, so the C function must have the standard arguments and return type 
expected by that function, as e.g. the **ccommand** subcommand creates.

Synopsis:

    $handle linktclcommand <CSymbol> <TclCommandName> ?<ClientData>?
    
### $handle tk
Request that Tk be used for this handle.  Ensures the Tk stubs interface is 
properly initialized.

Synopsis:

    $handle tk

### $handle add_include_path
Search additional paths for header files

Synopsis:

    $handle add_include_path <dir...>

### $handle add_library_path
Search additional paths for libraries

Synopsis:

    $handle add_library_path <dir...>

### $handle add_library
Link to an additional library.  See TinyCC code for file name patterns that 
will be recognized as library files.  For example, in the case of shared 
libraries, "libcurl.so" would be recognized but not "libcurl.so.4".

Synopsis:

    $handle add_library <library...>
    
### $handle add_file
Append contents of files to buffer of code to be compiled.

Synopsis:

    $handle add_file <file...>
    
### $handle process_command_line
Add configuration options using flags that mimic compiler flags.  Multiples of 
each flag can be used.

Synopsis:

    $handle process_command_line ?-I<dir>? ?-D<symbol>=<val>? ?-U<symbol>? \
    ?-l<library>? ?-L<dir>?
    
    -I add include path
    -D define preprocessor macro
    -U undefine preprocessor macro
    -l add library
    -L add library path
    
### $handle delete
Delete the handle before compilation and erase all code and configuration 
stored so far.

Synopsis:

    $handle delete

### $handle go
Execute all requested operations and output to memory, an executable, or DLL.

Once this command completes the handle is released.

Synopsis:

    $handle go
    
## tcc4tcl::cproc
Convenience function with the same arguments as the **cproc** handle 
subcommand; creates a new handle and compiles the provided code automatically, 
resulting in a Tcl procedure ready to use when the command returns.