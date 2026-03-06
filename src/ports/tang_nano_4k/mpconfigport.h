/* mpconfigport.h */
#include <stdint.h>

// options to control how MicroPython is built
#define MICROPY_CONFIG_ROM_LEVEL (MICROPY_CONFIG_ROM_LEVEL_MINIMUM)

#define MICROPY_ENABLE_GC (1)
#define MICROPY_HELPER_REPL (0)
#define MICROPY_ENABLE_COMPILER (0)

// type definitions for the specific machine
typedef intptr_t mp_int_t; // must be pointer size
typedef uintptr_t mp_uint_t; // must be pointer size
typedef long mp_off_t;

// board specifics
#define MICROPY_HW_BOARD_NAME "Tang Nano 4K"
#define MICROPY_HW_MCU_NAME   "GW1NSR-LV4C"

#define MICROPY_NO_ALLOCA (1)

// Root pointers
#define MICROPY_PORT_ROOT_POINTERS \
    const char *readline_hist[8];

#define MP_STATE_PORT MP_STATE_VM
