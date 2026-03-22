/* wdt.c */
#include "wdt.h"
#include "py/runtime.h"
#include "py/mphal.h"

typedef struct _machine_wdt_obj_t {
    mp_obj_base_t base;
} machine_wdt_obj_t;

static const machine_wdt_obj_t machine_wdt_obj = {{&machine_wdt_type}};

static mp_obj_t machine_wdt_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    mp_arg_check_num(n_args, n_kw, 0, 1, false);

    uint32_t timeout_ms = 5000;
    if (n_args > 0) {
        timeout_ms = mp_obj_get_int(args[0]);
    }

    // Default sys_clk = 27MHz
    uint32_t load_val = timeout_ms * 27000;

    // Unlock, configure and start WDT
    WDT0->LOCK = WDT_UNLOCK_VALUE;
    WDT0->LOAD = load_val;
    WDT0->CTRL = 3; // Bit 0: Enable interrupt (watchdog timer), Bit 1: Enable reset
    WDT0->LOCK = 0; // Lock again

    return MP_OBJ_FROM_PTR(&machine_wdt_obj);
}

static mp_obj_t machine_wdt_feed(mp_obj_t self_in) {
    (void)self_in;
    // Clearing the interrupt reloads the counter
    WDT0->LOCK = WDT_UNLOCK_VALUE;
    WDT0->INTCLR = 1;
    WDT0->LOCK = 0;
    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_1(machine_wdt_feed_obj, machine_wdt_feed);

static const mp_rom_map_elem_t machine_wdt_locals_dict_table[] = {
    { MP_ROM_QSTR(MP_QSTR_feed), MP_ROM_PTR(&machine_wdt_feed_obj) },
};
static MP_DEFINE_CONST_DICT(machine_wdt_locals_dict, machine_wdt_locals_dict_table);

MP_DEFINE_CONST_OBJ_TYPE(
    machine_wdt_type,
    MP_QSTR_WDT,
    MP_TYPE_FLAG_NONE,
    make_new, machine_wdt_make_new,
    locals_dict, &machine_wdt_locals_dict
);
