High-Level API Manual Page
==========================

    package require tcc4tcl

## tcc4tcl::new
Creates a new TCC interpreter instance.

Synposis:

    tcc4tcl::new ?<outputFile> ?<packageNameAndVersionsAsAList>??
    
Returns an opaque handle which is also a Tcl command to operate on.

If neither `<outputFile>` nor `<packageNameAndVersionsAsAList>` are specified, compilation (which happens when [$handle go] is called) is performed to memory.

If only `<outputFile>` is specified then an executable is written to the file named.

If `<packageNameAndVersionsAsAList>` is also specified then a Tcl extension is written as a shared library (shared object, dynamic library, dynamic linking library) to the file named. The format is a 2 or 3 element list: the first is the name of the package, the second is the package version number, the third if it exists is the minimum acceptable Tcl version number passed to the Tcl stubs library initialization function (defaults to TCL_VERSION macro in header file tcl.h).

Examples:

1. Create a handle that will compile to memory:

    set handle [tcc4tcl::new]

2. Create a handle that will compile to an executable named "myProgram":

    set handle [tcc4tcl::new myProgram]

3. Create a handle that will compile to a shared library named "myPackage" with the package name "myPackage" and version "1.0":

    set handle [tcc4tcl::new myPackage "myPackage 1.0"]

## $handle cproc
Creates a Tcl procedure that calls C code.

Synopsis:

    $handle cproc <procName> <argList> <returnType> ?<code>?
    
1. `<procName>` is the name of the Tcl procedure to create
2. `<argList>` is a list of arguments and their types for the C function;
    The list is in the format of: type1 name1 type2 name2 ... typeN nameN
    The supported types are:
        Tcl_Interp*: Must be first argument, will be the interpreter and the user will not need to pass this parameter
        int
        long
        float
        double
        char*
        Tcl_Obj*: Passes the Tcl object in unchanged
        Tcl_WideInt
        void*
3. `<returnType>` is the return type for the C function
    The supported types are:
        void: No return value
        ok: Return TCL_OK or TCL_ERROR
        int
        long
        float
        double
        Tcl_WideInt
        char*: TCL_STATIC string (immutable from C -- use this for constants)
        string, dstring: return a (char*) that is a TCL_DYNAMIC string
            (allocated from Tcl_Alloc, will be managed by Tcl)
        vstring: return a (char*) that is a TCL_VOLATILE string
            (mutable from C, will be copied be Tcl -- use this for local variables)
        default: Tcl_Obj*, a Tcl Object
4. `<code>` is the C code that comprises the function.
    If the `<code>` argument is omitted it is assumed there is already an implementation (with the name specified as <procName>, minus any namespace declarations) and this just creates the wrapper and Tcl command.

## $handle cwrap
Creates a Tcl procedure that wraps an existing C function

Synopsis:

    $handle cwrap <procName> <argList> <returnType>

    Notes:

This only differs from the cproc subcommand with no `<code>` argument in that it creates a prototype before referencing the function.

## $handle ccode
Compile arbitrary C code.

Synopsis:

    $handle ccode <code>

## $handle tk
Request that Tk be used for this handle.

Synposis:

    $handle tk
    
## $handle linktclcommand
Create a Tcl command that calls an existing C command as a Tcl command.

Synopsis:

    $handle linktclcommand <CSymbol> <TclCommandName> ?<ClientData>?

## $handle add_include_path
Search additional paths for header files

Synopsis:

    $handle add_include_path <dir...>

## $handle add_library_path
Search additional paths for libraries

Synopsis:

    $handle add_library_path <dir...>

## $handle add_library
Link to an additional library

Synopsis:

    $handle add_library <library...>

## $handle code
Return text of what code will be compiled when the go subcommand is called.

Synposis:

    $handle code

## $handle go
Execute all requested operations and output to memory, an executable, or DLL.

Once this command completes the handle is released.

Synopsis:

    $handle go