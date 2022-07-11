@rem ------------------------------------------------------
@rem batch file to build tcc using mingw, msvc or tcc itself
@rem ------------------------------------------------------
rem build-tcc4tcl-win32.bat -t 32 -c ../tcc_0.9.27-bin/gcc/bin/gcc.exe
rem  .\build-tcc4tcl-win32.bat -t 32 -c ..\..\tcc_0.9.27-bin\gcc\bin\gcc.exe -i C:\D\Toolbox\tcl\tcc4tclinst
@echo off
setlocal
if "%1"=="-clean" goto :cleanup
set CC=gcc
set INST=
set BIN=
set DOC=no
set EXES_ONLY=no
set HAS_WIN32_DIR=yes
set topdir=..
set tccdir=..\tcc
set tcc4tcldir=..
set win32=.
set /p VERSION= <%tccdir%\VERSION

del pkgIndex.tcl
setLocal EnableDelayedExpansion
For /f "tokens=* delims= " %%a in (%topdir%\pkgIndex.tcl.in) do (
Set str=%%a
set str=!str:@PACKAGE_VERSION@=0.30!
echo !str!>>pkgIndex.tcl
)
ENDLOCAL


goto :a0
:a2
shift
:a3
shift
:a0
if not "%1"=="-c" goto :a1
set CC=%~2
if "%2"=="cl" set CC=@call :cl
goto :a2
:a1
if "%1"=="-t" set T=%2&& goto :a2
if "%1"=="-v" set VERSION=%~2&& goto :a2
if "%1"=="-i" set INST=%2&& goto :a2
if "%1"=="-b" set BIN=%2&& goto :a2
if "%1"=="-d" set DOC=yes&& goto :a3
if "%1"=="-x" set EXES_ONLY=yes&& goto :a3
if "%1"=="-u" set HAS_WIN32_DIR=no&& goto :a3
if "%1"=="" goto :p1
:usage
echo usage: build-tcc.bat [ options ... ]
echo options:
echo   -c prog              use prog (gcc/tcc/cl) to compile tcc
echo   -c "prog options"    use prog with options to compile tcc
echo   -t 32/64             force 32/64 bit default target
echo   -v "version"         set tcc version
echo   -i tccdir            install tcc into tccdir
echo   -b bindir            optionally install binaries into bindir elsewhere
echo   -d                   create tcc-doc.html too (needs makeinfo)
echo   -x                   just create the executables
echo   -u                   use unified include dir (else will install two include paths include and win32
echo   -clean               delete all previously produced files and directories
exit /B 1

@rem ------------------------------------------------------
@rem sub-routines

:cleanup
echo Cleanup 
set LOG=echo
%LOG% removing files (partially outcommented MiR):
rem for %%f in (*tcc.exe libtcc.dll lib\*.a) do call :del_file %%f
for %%f in (%tccdir%\config.h %tccdir%\config.texi) do call :del_file %%f
rem for %%f in (include\*.h) do @if exist ..\%%f call :del_file %%f
rem for %%f in (include\tcclib.h examples\libtcc_test.c) do call :del_file %%f
for %%f in (*.o *.obj *.def *.pdb *.lib *.exp *.ilk) do call :del_file %%f
goto :the_end
%LOG% removing directories:
for %%f in (doc libtcc) do call :del_dir %%f
%LOG% done.
exit /B 0
:del_file
if exist %1 del %1 && %LOG%   %1
exit /B 0
:del_dir
if exist %1 rmdir /Q/S %1 && %LOG%   %1
exit /B 0

:cl
@echo off
set CMD=cl
:c0
set ARG=%1
set ARG=%ARG:.dll=.lib%
if "%1"=="-shared" set ARG=-LD
if "%1"=="-o" shift && set ARG=-Fe%2
set CMD=%CMD% %ARG%
shift
if not "%1"=="" goto :c0
echo on
%CMD% -O1 -W2 -Zi -MT -GS- -nologo -link -opt:ref,icf
@exit /B %ERRORLEVEL%

@rem ------------------------------------------------------
@rem main program

:p1
echo starting
echo Version %VERSION%
echo T %T%
echo HAS_WIN32_DIR %HAS_WIN32_DIR%
rem goto :copy-install

if not %T%_==_ goto :p2
set T=32
if %PROCESSOR_ARCHITECTURE%_==AMD64_ set T=64
if %PROCESSOR_ARCHITEW6432%_==AMD64_ set T=64
:p2
if "%CC:~-3%"=="gcc" set CC=%CC% -Os -s -static
set D32=-DTCC_TARGET_PE -DTCC_TARGET_I386 -D_WIN32 -m32
set D64=-DTCC_TARGET_PE -DTCC_TARGET_X86_64 -D_WIN64
set P32=i386-win32
set P64=x86_64-win32
if %T%==64 goto :t64
set D=%D32%
set DX=%D64%
set PX=%P64%
goto :p3
:t64
set D=%D64%
set DX=%D32%
set PX=%P32%
goto :p3

:p3
@echo off

:config.h
echo building config
echo>%tccdir%\config.h #define TCC_VERSION "%VERSION%"
echo>> %tccdir%\config.h #ifdef TCC_TARGET_X86_64
echo>> %tccdir%\config.h #define TCC_LIBTCC1 "libtcc1-64.a"
echo>> %tccdir%\config.h #else
echo>> %tccdir%\config.h #define TCC_LIBTCC1 "libtcc1-32.a"
echo>> %tccdir%\config.h #endif
echo>>%tccdir%\config.h #ifdef _WIN32
echo>>%tccdir%\config.h #define CONFIG_WIN32 1
echo>>%tccdir%\config.h #define TCC_TARGET_PE 1
echo>>%tccdir%\config.h #endif
echo>>%tccdir%\config.h #define HOST_I386 1
echo>>%tccdir%\config.h #ifndef TCC_TARGET_X86_64
echo>>%tccdir%\config.h #define TCC_TARGET_I386 1
echo>>%tccdir%\config.h #endif
echo>>%tccdir%\config.h #ifdef _WIN32
echo>>%tccdir%\config.h #define _USE_32BIT_TIME_T 1
echo>>%tccdir%\config.h #include ^<stdint.h^>
echo>>%tccdir%\config.h typedef __int64 __time64_t;
echo>>%tccdir%\config.h #endif
if "%HAS_WIN32_DIR%"=="yes" echo>>%tccdir%\config.h #define CONFIG_TCC_SYSINCLUDEPATHS "{B}/include;{B}/include/winapi;{B}/win32;{B}/win32/winapi"

for %%f in (*tcc.exe *tcc.dll) do @del %%f

:compiler
echo start compiling %D% 
@echo off
%CC% -o libtcc.dll -shared -s %tccdir%\libtcc.c %D% -DLIBTCC_AS_DLL -O2
@if errorlevel 1 goto :the_end
%CC% -s -o tcc.exe %tccdir%\tcc.c libtcc.dll %D% -DONE_SOURCE"=0" -O2 -fwhole-program
echo start compiling %PX% %DX% 
%CC% -o %PX%-tcc.exe %tccdir%\tcc.c %DX% -O2

:tcc4tcl
echo starting build tcc4tcl
rem %CC% %target% %tccdir%/tcc.c -o tcc.exe -ltcc -Llibtcc
echo %CC% %target% -Wfatal-errors -DHAVE_TCL_H %D% -I%tccdir% -I%topdir%/include/generic -c %tccdir%/tcc.c  -L%topdir%/lib -ltclstub86 -o"libtcc.o" -O2
%CC% %target% -Wfatal-errors -DHAVE_TCL_H %D% -I%tccdir% -I%topdir%/include/generic -c %tccdir%/tcc.c  -L%topdir%/lib -ltclstub86 -o"libtcc.o" -O2
echo %CC% %target% -shared -s -DHAVE_TCL_H %D% -static-libgcc -I%tccdir% -I%topdir%/include/generic -I%topdir%/include/generic/win -Itcc  %tcc4tcldir%/tcc4tcl.c  -L%topdir%/lib -ltclstub86  "libtcc.o" -o"tcc4tcl.dll"
%CC% %target% -shared -s -DHAVE_TCL_H %D% -static-libgcc -I%tccdir% -I%topdir%/include/generic -I%topdir%/include/generic/win -Itcc  %tcc4tcldir%/tcc4tcl.c  -L%topdir%/lib -ltclstub86  "libtcc.o" -o"tcc4tcl.dll"

@if "%EXES_ONLY%"=="yes" goto :files-done


:copy-libtcc
echo copy libtcc %tccdir% to %win32%\libtcc
if not exist %win32%\libtcc mkdir %win32%\libtcc
rem if not exist doc mkdir doc
copy>nul %tccdir%\include\*.h %win32%\include
copy>nul %tccdir%\tcclib.h %win32%\include
copy>nul %tccdir%\libtcc.h %win32%\libtcc
rem copy>nul ..\tests\libtcc_test.c examples
rem copy>nul tcc-win32.txt doc

echo building def
.\tcc -impdef libtcc.dll -o %win32%\libtcc\libtcc.def
@if errorlevel 1 goto :the_end

:libtcc1.a
set inc=-Iwin32 -Iwin32/winapi
echo building libtcc1 with includes %inc%
@set O1=libtcc1.o crt1.o crt1w.o wincrt1.o wincrt1w.o dllcrt1.o dllmain.o chkstk.o bcheck.o
.\tcc %inc% -m32 -c %tccdir%/lib/libtcc1.c
.\tcc %inc% -m32 -c %win32%/lib/crt1.c
.\tcc %inc% -m32 -c %win32%/lib/crt1w.c
.\tcc %inc% -m32 -c %win32%/lib/wincrt1.c
.\tcc %inc% -m32 -c %win32%/lib/wincrt1w.c
.\tcc %inc% -m32 -c %win32%/lib/dllcrt1.c
.\tcc %inc% -m32 -c %win32%/lib/dllmain.c
.\tcc %inc% -m32 -c %win32%/lib/chkstk.S
.\tcc %inc% -m32 -w -c %tccdir%/lib/bcheck.c
.\tcc %inc% -m32 -c %tccdir%/lib/alloca86.S
.\tcc %inc% -m32 -c %tccdir%/lib/alloca86-bt.S
.\tcc -m32 -ar lib/libtcc1-32.a %O1% alloca86.o alloca86-bt.o
@if errorlevel 1 goto :the_end
.\tcc %inc% -m64 -c %tccdir%/lib/libtcc1.c
.\tcc %inc% -m64 -c %win32%/lib/crt1.c
.\tcc %inc% -m64 -c %win32%/lib/crt1w.c
.\tcc %inc% -m64 -c %win32%/lib/wincrt1.c
.\tcc %inc% -m64 -c %win32%/lib/wincrt1w.c
.\tcc %inc% -m64 -c %win32%/lib/dllcrt1.c
.\tcc %inc% -m64 -c %win32%/lib/dllmain.c
.\tcc %inc% -m64 -c %win32%/lib/chkstk.S
.\tcc %inc% -m64 -w -c %tccdir%/lib/bcheck.c
.\tcc %inc% -m64 -c %tccdir%/lib/alloca86_64.S
.\tcc %inc% -m64 -c %tccdir%/lib/alloca86_64-bt.S
.\tcc -m64 -ar lib/libtcc1-64.a %O1% alloca86_64.o alloca86_64-bt.o
rem @if errorlevel 1 goto :the_end
echo ready...

:tcc-doc.html
@if not (%DOC%)==(yes) goto :doc-done
echo>..\config.texi @set VERSION %VERSION%
cmd /c makeinfo --html --no-split ../tcc-doc.texi -o doc/tcc-doc.html
:doc-done

:files-done
for %%f in (*.o *.def) do @del %%f

:copy-install
@if "%INST%"=="" goto :the_end
echo copy files to %INST%
if not exist %INST% mkdir %INST%
@if "%BIN%"=="" set BIN=%INST%
if not exist %BIN% mkdir %BIN%
for %%f in (*tcc.exe *tcc.dll *.dll %topdir%\*.tcl *.tcl) do @copy>nul %%f %BIN%\%%~nf%%~xf
@if not exist %INST%\lib mkdir %INST%\lib
for %%f in (%topdir%\lib\*.a %topdir%\lib\*.def lib\*.a lib\*.def %win32%\lib\*.*) do @copy>nul %%f %INST%\lib\%%~nf%%~xf
for %%f in (examples libtcc doc) do @xcopy>nul /s/i/q/y %win32%\%%f %INST%\%%f
echo copying %topdir%\include %INST%\include
xcopy /s/i/q/y %topdir%\include %INST%\include

set INSTWIN32=%INST%\include
if "%HAS_WIN32_DIR%"=="yes" set INSTWIN32=%INST%\win32

echo copying %topdir%\include %INSTWIN32%
if not exist %INSTWIN32% mkdir %INSTWIN32%
xcopy /s/i/q/y %win32%\include %INSTWIN32%

:the_end
exit /B %ERRORLEVEL%
