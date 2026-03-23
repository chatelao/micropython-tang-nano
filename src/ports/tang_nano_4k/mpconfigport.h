/* mpconfigport.h */
#include <stdint.h>

// options to control how MicroPython is built
#define MICROPY_CONFIG_ROM_LEVEL (MICROPY_CONFIG_ROM_LEVEL_MINIMUM)

#define MICROPY_ENABLE_GC (1)
#define MICROPY_HELPER_REPL (1)
#define MICROPY_ENABLE_COMPILER (1)
#define MICROPY_PY_TIME (1)

// type definitions for the specific machine
typedef intptr_t mp_int_t; // must be pointer size
typedef uintptr_t mp_uint_t; // must be pointer size
typedef long mp_off_t;

// board specifics
#define MICROPY_HW_BOARD_NAME "Tang Nano 4K"
#define MICROPY_HW_MCU_NAME   "GW1NSR-LV4C"
#define CPU_FREQ              (27000000)

#define MICROPY_NO_ALLOCA (1)

// Root pointers
#define MICROPY_PORT_ROOT_POINTERS \
    const char *readline_hist[8];

#define MP_STATE_PORT MP_STATE_VM

extern const struct _mp_obj_module_t mp_module_machine;
extern const struct _mp_obj_module_t mp_module_time;
#define MICROPY_PORT_BUILTIN_MODULES \
    { MP_ROM_QSTR(MP_QSTR_machine), MP_ROM_PTR(&mp_module_machine) }, \
    { MP_ROM_QSTR(MP_QSTR_time), MP_ROM_PTR(&mp_module_time) }, \
    { MP_ROM_QSTR(MP_QSTR_utime), MP_ROM_PTR(&mp_module_time) },

#define MICROPY_ENABLE_SCHEDULER (1)

#define MICROPY_PY_MACHINE_I2C (1)
#define MICROPY_PY_MACHINE_SOFTI2C (1)
#define MICROPY_PY_MACHINE_SPI (1)
#define MICROPY_PY_MACHINE_SOFTSPI (1)
#define MICROPY_PY_MACHINE_MEMX (1)

#define MICROPY_PY_BUILTINS_FLOAT (0)
#define MICROPY_PY_MATH (0)

#define MICROPY_VFS (1)
#define MICROPY_VFS_LFS2 (1)
#define MICROPY_PY_UOS (1)
#define MICROPY_PY_IO (1)
#define MICROPY_ENABLE_FINALISER (1)
#define MICROPY_READER_VFS (1)
#define MICROPY_PY_BUILTINS_BYTEARRAY (1)
