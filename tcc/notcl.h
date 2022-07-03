
#ifdef HAVE_TCL_H
#define TCL_OUTPUT_MEMORY TCC_OUTPUT_MEMORY
#else

#ifndef TCL_OK

#define TCL_OUTPUT_MEMORY 0

#define TCL_OK			0
#define TCL_ERROR		1
#define TCL_RETURN		2
#define TCL_BREAK		3
#define TCL_CONTINUE		4

#define TCL_STDIN		(1<<1)
#define TCL_STDOUT		(1<<2)
#define TCL_STDERR		(1<<3)
#define TCL_ENFORCE_MODE	(1<<4)

typedef int* Tcl_Channel;
typedef char Tcl_Obj;

#define Tcl_Read(fd,p,len) read((int)*fd, p, len)
#define Tcl_Seek(fd,p,len) lseek((int)*fd, p, len)
#define Tcl_Close(chan,fd) close((int)*fd)

#endif
#endif
