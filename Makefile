prefix = UNSPECIFIED
exec_prefix = ${prefix}
libdir = ${exec_prefix}/lib

TARGET = tcc4tcl.so

CC = gcc
CPP = gcc -E
AR = 
RANLIB = 
CFLAGS =  -D_GNU_SOURCE -DONE_SOURCE -DLIBTCC_AS_DLL -DUSE_TCL_STUBS -DTCC_TARGET_X86_64 -O2 -I/usr/include/tcl8.6 -I/usr/include/tcl8.6/tcl-private/ -I/usr/include/tcl8.6/tcl-private/generic -I/usr/include/tcl8.6/tcl-private/unix -I/usr/include/tcl8.6 -I/usr/include/tcl8.6 -fPIC
CPPFLAGS =  -I/usr/include/tcl8.6 -I$(shell cd . && pwd) -I$(shell cd . && pwd)/tcc -I$(shell pwd)/tcc -DPACKAGE_NAME=\"tcc4tcl\" -DPACKAGE_TARNAME=\"tcc4tcl\" -DPACKAGE_VERSION=\"0.30\" -DPACKAGE_STRING=\"tcc4tcl\ 0.30\" -DPACKAGE_BUGREPORT=\"\" -DPACKAGE_URL=\"\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -D__EXTENSIONS__=1 -D_ALL_SOURCE=1 -D_GNU_SOURCE=1 -D_POSIX_PTHREAD_SEMANTICS=1 -D_TANDEM_SOURCE=1 -DMODULE_SCOPE=static -DUSE_TCL_STUBS=1 -DPIC
LDFLAGS = 
SHOBJLDFLAGS = -shared -Wl,--version-script,./tcc4tcl.vers
LIBS =  -L/usr/lib/x86_64-linux-gnu -ltclstub8.6
INSTALL = /usr/bin/install -c
TCLSH = /usr/bin/tclsh

PACKAGE_NAME = tcc4tcl
PACKAGE_VERSION = 0.30

TCLCONFIGPATH = /usr/lib/tcl8.6/
TCL_PACKAGE_PATH = /usr/local/lib/tcltk
tcllibdir = $(shell if echo "$(libdir)" | grep '^UNSPECIFIED' >/dev/null; then echo $(TCL_PACKAGE_PATH); else echo "$(libdir)"; fi)
PACKAGE_INSTALL_DIR = $(tcllibdir)/$(PACKAGE_NAME)-$(PACKAGE_VERSION)
TCC_CONFIGURE_OPTS = --cc='$(CC)' --extra-cflags='$(CPPFLAGS) $(CFLAGS) -DSHOBJEXT=so ' --with-tcl=$(TCLCONFIGPATH) --sysincludepaths='{B}/include:{B}/include/1:{B}/include/2:{B}/include/3:{B}/include/4:{B}/include/5:{B}/include/6:{B}/include/7:{B}/include/8:{B}/include/9' --libpaths='{B}/lib' 
INSTALL_HEADERS = tcl.h assert.h ctype.h errno.h float.h limits.h locale.h math.h setjmp.h signal.h stdarg.h stddef.h stdint.h stdio.h stdlib.h string.h time.h wctype.h
srcdir = .
host_os = linux-gnu


all: $(TARGET) tcc/libtcc1.a

tcc/config.h:
	if [ "$(srcdir)" = "." ]; then \
		cd tcc && ./configure $(TCC_CONFIGURE_OPTS); \
	else \
		mkdir tcc >/dev/null 2>/dev/null; \
		cd tcc && $(shell cd $(srcdir) && pwd)/tcc/configure $(TCC_CONFIGURE_OPTS); \
	fi

tcc/libtcc.a: tcc/config.h
	$(MAKE) -C tcc libtcc.a

tcc/libtcc1.a: tcc/config.h
	-$(MAKE) -C tcc tcc
	$(MAKE) -C tcc libtcc1.a

libtcc.o: $(srcdir)/tcc/tcc.h $(srcdir)/tcc/libtcc.h tcc/config.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -o libtcc.o -c $(srcdir)/tcc/tcc.c 
	
tcc4tcl.o: $(srcdir)/tcc4tcl.c $(srcdir)/tcc/tcc.h $(srcdir)/tcc/libtcc.h tcc/config.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -o tcc4tcl.o -c $(srcdir)/tcc4tcl.c

tcc4tcl.so: tcc4tcl.o libtcc.o
	$(CC) -shared -s -o tcc4tcl.so tcc4tcl.o libtcc.o $(LIBS)
	-objcopy --keep-global-symbols=tcc4tcl.syms tcc4tcl.so
	-objcopy --discard-all tcc4tcl.so

tcc4tcl-static.a: tcc4tcl.o tcc/libtcc.a
	cp tcc/libtcc.a tcc4tcl-static.new.a
	$(AR) rcu tcc4tcl-static.new.a tcc4tcl.o
	-$(RANLIB) tcc4tcl-static.new.a
	mv tcc4tcl-static.new.a tcc4tcl-static.a

install: $(TARGET) pkgIndex.tcl $(srcdir)/tcc4tcl.tcl $(srcdir)/tcc4critcl.tcl tcc/libtcc1.a $(shell echo $(srcdir)/tcc/include/*) $(shell echo $(srcdir)/tcc/win32/lib/*.c) $(srcdir)/headers.awk $(srcdir)/patch-headers.sh
	$(INSTALL) -d "$(DESTDIR)$(PACKAGE_INSTALL_DIR)"
	$(INSTALL) -d "$(DESTDIR)$(PACKAGE_INSTALL_DIR)/lib"
	$(INSTALL) -d "$(DESTDIR)$(PACKAGE_INSTALL_DIR)/include"
	$(INSTALL) -m 0755 $(TARGET) "$(DESTDIR)$(PACKAGE_INSTALL_DIR)"
	$(INSTALL) -m 0644 pkgIndex.tcl "$(DESTDIR)$(PACKAGE_INSTALL_DIR)"
	$(INSTALL) -m 0644 $(srcdir)/tcc4tcl.tcl "$(DESTDIR)$(PACKAGE_INSTALL_DIR)"
	$(INSTALL) -m 0644 $(srcdir)/tcc4critcl.tcl "$(DESTDIR)$(PACKAGE_INSTALL_DIR)"
	$(INSTALL) -m 0644 tcc/libtcc1.a "$(DESTDIR)$(PACKAGE_INSTALL_DIR)/lib"
	$(INSTALL) -m 0644 $(shell echo $(srcdir)/tcc/win32/lib/*.c) "$(DESTDIR)$(PACKAGE_INSTALL_DIR)/lib"
	$(INSTALL) -m 0644 $(shell echo $(srcdir)/tcc/include/*) "$(DESTDIR)$(PACKAGE_INSTALL_DIR)/include"
	@if ! echo "_WIN32" | $(CPP) $(CPPFLAGS) - | grep '^_WIN32$$' >/dev/null; then \
		echo cp -r $(srcdir)/tcc/win32/include/* "$(DESTDIR)$(PACKAGE_INSTALL_DIR)/include/"; \
		cp -r $(srcdir)/tcc/win32/include/* "$(DESTDIR)$(PACKAGE_INSTALL_DIR)/include/"; \
		echo cp -r $(srcdir)/tcc/win32/lib/*.def "$(DESTDIR)$(PACKAGE_INSTALL_DIR)/lib/"; \
		cp -r $(srcdir)/tcc/win32/lib/*.def "$(DESTDIR)$(PACKAGE_INSTALL_DIR)/lib/"; \
	fi
	( for file in $(INSTALL_HEADERS); do echo "#include <$${file}>"; done ) | \
		$(CPP) -v $(CPPFLAGS) -I$(srcdir)/tcc/include -I$(srcdir)/tcc/include - 2>&1 | gawk -f $(srcdir)/headers.awk | while read src dst; do \
			dst="$(DESTDIR)$(PACKAGE_INSTALL_DIR)/include/$$dst"; \
			if [ -e "$${dst}" ]; then continue; fi; \
			dstdir="$$(dirname "$$dst")"; \
			mkdir -p "$$dstdir"; \
			echo cp "$$src" "$$dst"; \
			cp "$$src" "$$dst"; \
		done
	$(srcdir)/patch-headers.sh "$(DESTDIR)$(PACKAGE_INSTALL_DIR)/include"

test: test.tcl
	rm -rf __TMP__
	$(MAKE) install tcllibdir=$(shell pwd)/__TMP__
	-if [ "$(PACKAGE_VERSION)" = '@@VERS@@' ]; then cd __TMP__/* && ( \
		for file in tcc4tcl.tcl tcc4critcl.tcl pkgIndex.tcl; do \
			sed 's/@@VERS@@/0.0/g' "$${file}" > "$${file}.new"; \
			cat "$${file}.new" > "$${file}"; \
			rm -f "$${file}.new"; \
		done \
	); fi
	if [ 'x86_64-unknown-linux-gnu' = 'x86_64-unknown-linux-gnu' ]; then TCC4TCL_TEST_RUN_NATIVE=1; export TCC4TCL_TEST_RUN_NATIVE; fi; $(TCLSH) $(srcdir)/test.tcl __TMP__
	echo Tests Completed OK > TEST-STATUS
	rm -rf __TMP__

clean:
	rm -f tcc4tcl.o
	rm -f tcc4tcl.so tcc4tcl-static.a
	rm -f tcc4tcl.so.a tcc4tcl.so.def
	rm -rf __TMP__
	rm -f TEST-STATUS
	-$(MAKE) -C tcc distclean

distclean: clean
	rm -rf autom4te.cache
	rm -f config.log config.status
	rm -f pkgIndex.tcl tcc4tcl.syms
	rm -f Makefile tcc/Makefile

mrproper: distclean
	rm -rf tcc
	rm -f configure aclocal.m4
	rm -f config.guess config.sub install-sh

.PHONY: all install test clean distclean mrproper
