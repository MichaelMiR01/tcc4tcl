#ifdef _WIN32
#define CONFIG_WIN32 1
#define TCC_TARGET_PE 1
#endif
#define HOST_I386 1
#ifndef TCC_TARGET_X86_64
#define TCC_TARGET_I386 1
#endif
#define TCC_VERSION "0.9.27"

#define _USE_32BIT_TIME_T 1

//define PE_PRINT_SECTIONS

#ifndef _WIN32
#include <stdint.h>
#endif

#ifndef _WIN32
#ifdef TCC_TARGET_X86_64
# define CONFIG_LDDIR "lib/x86_64-linux-gnu"
#endif
#endif

#ifdef _WIN32
typedef __int64 __time64_t;
#endif
