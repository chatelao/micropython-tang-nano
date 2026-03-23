/* rtc.c */
#include "py/runtime.h"
#include "py/mphal.h"
#include "rtc.h"
#include "shared/timeutils/timeutils.h"

typedef struct _machine_rtc_obj_t {
    mp_obj_base_t base;
} machine_rtc_obj_t;

static const machine_rtc_obj_t machine_rtc_obj = {{&machine_rtc_type}};

static mp_obj_t machine_rtc_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    mp_arg_check_num(n_args, n_kw, 0, 0, false);
    RTC0->CTRL |= 1; // Start RTC counter if not already started
    return MP_OBJ_FROM_PTR(&machine_rtc_obj);
}

static mp_obj_t machine_rtc_datetime(size_t n_args, const mp_obj_t *args) {
    if (n_args == 1) {
        // Get time
        uint32_t seconds = RTC0->CURRENT_DATA;
        timeutils_struct_time_t tm;
        timeutils_seconds_since_2000_to_struct_time(seconds, &tm);

        mp_obj_t tuple[8] = {
            mp_obj_new_int(tm.tm_year),
            mp_obj_new_int(tm.tm_mon),
            mp_obj_new_int(tm.tm_mday),
            mp_obj_new_int(tm.tm_wday + 1), // MicroPython uses 1-7 for Mon-Sun
            mp_obj_new_int(tm.tm_hour),
            mp_obj_new_int(tm.tm_min),
            mp_obj_new_int(tm.tm_sec),
            mp_obj_new_int(0) // subseconds
        };
        return mp_obj_new_tuple(8, tuple);
    } else {
        // Set time
        mp_obj_t *items;
        mp_obj_get_array_fixed_n(args[1], 8, &items);

        uint32_t seconds = timeutils_seconds_since_2000(
            mp_obj_get_int(items[0]),
            mp_obj_get_int(items[1]),
            mp_obj_get_int(items[2]),
            mp_obj_get_int(items[4]),
            mp_obj_get_int(items[5]),
            mp_obj_get_int(items[6])
        );

        RTC0->LOAD_VALUE = seconds;
        return mp_const_none;
    }
}
static MP_DEFINE_CONST_FUN_OBJ_VAR_BETWEEN(machine_rtc_datetime_obj, 1, 2, machine_rtc_datetime);

static const mp_rom_map_elem_t machine_rtc_locals_dict_table[] = {
    { MP_ROM_QSTR(MP_QSTR_datetime), MP_ROM_PTR(&machine_rtc_datetime_obj) },
};
static MP_DEFINE_CONST_DICT(machine_rtc_locals_dict, machine_rtc_locals_dict_table);

MP_DEFINE_CONST_OBJ_TYPE(
    machine_rtc_type,
    MP_QSTR_RTC,
    MP_TYPE_FLAG_NONE,
    make_new, machine_rtc_make_new,
    locals_dict, &machine_rtc_locals_dict
);
