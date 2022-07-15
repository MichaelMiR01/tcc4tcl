tcc4tcl Examples
================

## Simple Example

    #! /usr/bin/env tclsh
    
    package require tcc4tcl
    set handle [tcc4tcl::new]
    $handle cproc add {int a int b} long { return(a+b); }
    $handle go
    puts [add 1 2]

## Example 1: mkdir

    #! /usr/bin/env tclsh
    
    package require tcc4tcl
    
    tcc4tcl::cproc mkdir {Tcl_Interp* interp char* dir} ok {
            int mkdir_ret;
    
            mkdir_ret = mkdir(dir);
    
            if (mkdir_ret != 0) {
                    Tcl_SetObjResult(interp, Tcl_NewStringObj("failed", -1));
                    return(TCL_ERROR);
            };
    
            return(TCL_OK);
    }

## Example 2: curl

    #! /usr/bin/env tclsh
    
    package require tcc4tcl
    
    set handle [tcc4tcl::new]
    
    $handle ccode {
    #include <stdint.h>
    #include <curl/curl.h>
    }
    $handle cwrap curl_version {} vstring
    $handle cproc curl_fetch {char* url} ok {
            void *handle;
    
            handle = curl_easy_init();
            if (!handle) {
                    return(TCL_ERROR);
            }
    
            curl_easy_setopt(handle, CURLOPT_URL, url);
            curl_easy_perform(handle);
    
            return(TCL_OK);
    }
    $handle add_library_path /usr/lib64
    $handle add_include_path /usr/include
    $handle add_library curl
    $handle go
    
    curl_fetch http://rkeene.org/
    
----------------------------------

See the file test.tcl for more example code.