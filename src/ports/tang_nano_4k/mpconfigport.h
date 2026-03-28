/* mpconfigport.h */
#include <stdint.h>

// options to control how MicroPython is built
#define MICROPY_CONFIG_ROM_LEVEL (MICROPY_CONFIG_ROM_LEVEL_EXTRA_FEATURES)

#define MICROPY_ENABLE_GC (1)
#define MICROPY_GC_SPLIT_HEAP (1)
#define MICROPY_HELPER_REPL (1)
#define MICROPY_PY_TIME (1)

// type definitions for the specific machine
typedef intptr_t mp_int_t; // must be pointer size
typedef uintptr_t mp_uint_t; // must be pointer size
typedef long mp_off_t;

// board specifics
#define MICROPY_HW_BOARD_NAME "Tang Nano 4K"
#define MICROPY_HW_MCU_NAME   "GW1NSR-LV4C"
#define CPU_FREQ              (27000000)

#include <sys/types.h>
#ifndef SSIZE_MAX
#define SSIZE_MAX INTPTR_MAX
#endif

#define MICROPY_NO_ALLOCA (1)

// Root pointers
#define MICROPY_PORT_ROOT_POINTERS \
    const char *readline_hist[8];

#define MP_STATE_PORT MP_STATE_VM

extern const struct _mp_obj_module_t mp_module_machine;
extern const struct _mp_obj_module_t mp_module_time;
extern const struct _mp_obj_module_t mp_module_gc;
extern const struct _mp_obj_module_t mp_module_struct;
#define MICROPY_PORT_BUILTIN_MODULES \
    { MP_ROM_QSTR(MP_QSTR_machine), MP_ROM_PTR(&mp_module_machine) }, \
    { MP_ROM_QSTR(MP_QSTR_time), MP_ROM_PTR(&mp_module_time) }, \
    { MP_ROM_QSTR(MP_QSTR_utime), MP_ROM_PTR(&mp_module_time) }, \
    { MP_ROM_QSTR(MP_QSTR_gc), MP_ROM_PTR(&mp_module_gc) }, \
    { MP_ROM_QSTR(MP_QSTR_struct), MP_ROM_PTR(&mp_module_struct) },

#define MICROPY_ENABLE_SCHEDULER (1)

#define MICROPY_PY_MACHINE_I2C (1)
#define MICROPY_PY_MACHINE_SOFTI2C (1)
#define MICROPY_PY_MACHINE_SPI (1)
#define MICROPY_PY_MACHINE_SOFTSPI (1)
#define MICROPY_PY_MACHINE_MEMX (1)

#define MICROPY_OBJ_REPR (MICROPY_OBJ_REPR_C)
#define MICROPY_FLOAT_IMPL (MICROPY_FLOAT_IMPL_FLOAT)

#define MICROPY_VFS (1)
#define MICROPY_VFS_LFS2 (1)
#define MICROPY_PY_UOS (1)
#define MICROPY_PY_IO (1)
#define MICROPY_PY_IO_IOBASE (1)
#define MICROPY_LONGINT_IMPL (MICROPY_LONGINT_IMPL_MPZ)
#define MICROPY_ENABLE_FINALISER (1)
#define MICROPY_READER_VFS (1)
#define MICROPY_PY_GC (1)

// Additional features
#define MICROPY_PY_BUILTINS_HELP (1)
#define MICROPY_PY_BUILTINS_HELP_TEXT tang_nano_4k_help_text

// Explicitly disable VFS FAT and POSIX to avoid missing headers
#define MICROPY_VFS_FAT (0)
#define MICROPY_VFS_POSIX (0)

#define FFCONF_H "lib/oofatfs/ffconf.h"

// Optimization to reduce size
#define MICROPY_PY_BUILTINS_COMPLEX (1)
#ifdef SIMULATION
#define MICROPY_ERROR_REPORTING (MICROPY_ERROR_REPORTING_DETAILED)
#else
#define MICROPY_ERROR_REPORTING (MICROPY_ERROR_REPORTING_NONE)
#endif
#define MICROPY_PY_MATH (1)
#define MICROPY_PY_CMATH (1)

// Specific feature enabling
#define MICROPY_PY_SYS_MAXSIZE (1)
#define MICROPY_PY_BUILTINS_PROPERTY (1)

// Disable features that require port-specific implementations not yet available
#define MICROPY_PY_UCTYPES (0)
#define MICROPY_PY_SYS_STDFILES (0)
#define MICROPY_PY_SYS_STDIO_BUFFER (0)
