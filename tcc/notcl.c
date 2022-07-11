#ifndef HAVE_TCL_H
Tcl_Channel Tcl_FSOpenFileChannel(void *interp,
				Tcl_Obj *pathPtr, const char *modeString,
				int permissions)  {
    int fd;
    int* fptr;
    // dynamic memory allocation using malloc()

    fd= open(pathPtr,O_RDONLY | O_BINARY);
    if(fd<0) return NULL;
    fptr = (int *) tcc_malloc(sizeof(int));
    fptr[0]=fd;
    //printf("opening %s %d %u\n",pathPtr,fd,fptr);
    return fptr;
}
Tcl_Channel Tcl_GetStdChannel(int type) {return 0;}
int Tcl_GetChannelHandle(Tcl_Channel chan, int direction, void *handlePtr) {
    handlePtr=&chan;
    return TCL_OK;
}

char* Tcl_NewStringObj(const char* filename,int n) {return filename;}
int Tcl_IncrRefCount(void* o) {return TCL_OK;}
int Tcl_DecrRefCount(void* o) {return TCL_OK;}
#endif