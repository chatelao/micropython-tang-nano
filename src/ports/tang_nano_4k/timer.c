#include <stdint.h>
#include "py/runtime.h"
#include "py/mperrno.h"
#include "py/mphal.h"
#include "timer.h"

#define MAX_TIMERS 4
MP_REGISTER_ROOT_POINTER(struct _machine_timer_obj_t *active_timers[4]);

typedef enum {
    TIMER_MODE_ONE_SHOT,
    TIMER_MODE_PERIODIC,
} timer_mode_t;

typedef struct _machine_timer_obj_t {
    mp_obj_base_t base;
    uint32_t period;
    timer_mode_t mode;
    mp_obj_t callback;
    uint32_t last_tick;
    bool active;
} machine_timer_obj_t;

void machine_timer_tick_all(void) {
    uint32_t current_tick = mp_hal_ticks_ms();
    for (int i = 0; i < MAX_TIMERS; i++) {
        machine_timer_obj_t *timer = MP_STATE_PORT(active_timers)[i];
        if (timer && timer->active && (current_tick - timer->last_tick >= timer->period)) {
            if (timer->callback != mp_const_none) {
                mp_sched_schedule(timer->callback, MP_OBJ_FROM_PTR(timer));
            }
            if (timer->mode == TIMER_MODE_ONE_SHOT) {
                timer->active = false;
            } else {
                timer->last_tick = current_tick;
            }
        }
    }
}

static void machine_timer_print(const mp_print_t *print, mp_obj_t self_in, mp_print_kind_t kind) {
    machine_timer_obj_t *self = MP_OBJ_TO_PTR(self_in);
    mp_printf(print, "Timer(period=%u, mode=%u, active=%u)",
        (unsigned int)self->period, (unsigned int)self->mode, (unsigned int)self->active);
}

static mp_obj_t machine_timer_init_helper(machine_timer_obj_t *self, size_t n_args, const mp_obj_t *pos_args, mp_map_t *kw_args) {
    enum { ARG_period, ARG_mode, ARG_callback };
    static const mp_arg_t allowed_args[] = {
        { MP_QSTR_period, MP_ARG_KW_ONLY | MP_ARG_INT, {.u_int = 1000} },
        { MP_QSTR_mode, MP_ARG_KW_ONLY | MP_ARG_INT, {.u_int = TIMER_MODE_PERIODIC} },
        { MP_QSTR_callback, MP_ARG_KW_ONLY | MP_ARG_OBJ, {.u_obj = mp_const_none} },
    };

    mp_arg_val_t vals[MP_ARRAY_SIZE(allowed_args)];
    mp_arg_parse_all(n_args, pos_args, kw_args, MP_ARRAY_SIZE(allowed_args), allowed_args, vals);

    self->period = vals[ARG_period].u_int;
    self->mode = vals[ARG_mode].u_int;
    self->callback = vals[ARG_callback].u_obj;
    self->last_tick = mp_hal_ticks_ms();

    // Re-register in the pool if not present (e.g. after deinit)
    bool found = false;
    int first_empty = -1;
    for (int i = 0; i < MAX_TIMERS; i++) {
        if (MP_STATE_PORT(active_timers)[i] == self) {
            found = true;
            break;
        }
        if (first_empty == -1 && MP_STATE_PORT(active_timers)[i] == NULL) {
            first_empty = i;
        }
    }

    if (!found) {
        if (first_empty == -1) {
            mp_raise_OSError(MP_ENOMEM);
        }
        MP_STATE_PORT(active_timers)[first_empty] = self;
    }

    self->active = true;

    return mp_const_none;
}

static mp_obj_t machine_timer_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    mp_arg_check_num(n_args, n_kw, 0, MP_OBJ_FUN_ARGS_MAX, true);

    machine_timer_obj_t *self = mp_obj_malloc(machine_timer_obj_t, &machine_timer_type);
    self->base.type = &machine_timer_type;
    self->active = false;
    self->callback = mp_const_none;

    if (n_args > 0) {
        // timer_id is currently ignored as we use a software pool
        mp_obj_get_int(args[0]);
    }

    // Find a slot for the timer
    int slot = -1;
    for (int i = 0; i < MAX_TIMERS; i++) {
        if (MP_STATE_PORT(active_timers)[i] == NULL) {
            slot = i;
            break;
        }
    }

    if (slot == -1) {
        mp_raise_OSError(MP_ENOMEM);
    }

    MP_STATE_PORT(active_timers)[slot] = self;

    if (n_args > 1 || n_kw > 0) {
        // Handle timer initialization
        mp_map_t kw_args;
        mp_map_init_fixed_table(&kw_args, n_kw, args + n_args);
        machine_timer_init_helper(self, n_args - 1, args + 1, &kw_args);
    }

    return MP_OBJ_FROM_PTR(self);
}

static mp_obj_t machine_timer_init(size_t n_args, const mp_obj_t *args, mp_map_t *kw_args) {
    return machine_timer_init_helper(MP_OBJ_TO_PTR(args[0]), n_args - 1, args + 1, kw_args);
}
static MP_DEFINE_CONST_FUN_OBJ_KW(machine_timer_init_obj, 1, machine_timer_init);

static mp_obj_t machine_timer_deinit(mp_obj_t self_in) {
    machine_timer_obj_t *self = MP_OBJ_TO_PTR(self_in);
    self->active = false;
    for (int i = 0; i < MAX_TIMERS; i++) {
        if (MP_STATE_PORT(active_timers)[i] == self) {
            MP_STATE_PORT(active_timers)[i] = NULL;
            break;
        }
    }
    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_1(machine_timer_deinit_obj, machine_timer_deinit);

static const mp_rom_map_elem_t machine_timer_locals_dict_table[] = {
    { MP_ROM_QSTR(MP_QSTR_init), MP_ROM_PTR(&machine_timer_init_obj) },
    { MP_ROM_QSTR(MP_QSTR_deinit), MP_ROM_PTR(&machine_timer_deinit_obj) },
    { MP_ROM_QSTR(MP_QSTR_ONE_SHOT), MP_ROM_INT(TIMER_MODE_ONE_SHOT) },
    { MP_ROM_QSTR(MP_QSTR_PERIODIC), MP_ROM_INT(TIMER_MODE_PERIODIC) },
};
static MP_DEFINE_CONST_DICT(machine_timer_locals_dict, machine_timer_locals_dict_table);

MP_DEFINE_CONST_OBJ_TYPE(
    machine_timer_type,
    MP_QSTR_Timer,
    MP_TYPE_FLAG_NONE,
    make_new, machine_timer_make_new,
    print, machine_timer_print,
    locals_dict, &machine_timer_locals_dict
    );
