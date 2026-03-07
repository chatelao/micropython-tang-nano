#include <stdint.h>
#include "py/runtime.h"
#include "py/mperrno.h"
#include "py/mphal.h"
#include "pin.h"
#include "pwm.h"

#define TIMER1_BASE 0x40001000
#define TIMER1_CTRL (*(volatile uint32_t *)(TIMER1_BASE + 0x00))
#define TIMER1_RELOAD (*(volatile uint32_t *)(TIMER1_BASE + 0x08))
#define TIMER1_INTCLEAR (*(volatile uint32_t *)(TIMER1_BASE + 0x0C))

#define GPIO_BASE (0x40010000)
#define REG_DATAOUT (*(volatile uint32_t *)(GPIO_BASE + 0x0004))
#define REG_OUTENSET (*(volatile uint32_t *)(GPIO_BASE + 0x0010))
#define REG_ALTFUNCCLR (*(volatile uint32_t *)(GPIO_BASE + 0x001C))

#define NVIC_ISER0 (*(volatile uint32_t *)(0xE000E100))

#define MAX_PWM 8
MP_REGISTER_ROOT_POINTER(struct _machine_pwm_obj_t *active_pwm[8]);

#define PWM_RESOLUTION 100

typedef struct _machine_pwm_obj_t {
    mp_obj_base_t base;
    uint32_t pin_id;
    uint32_t freq;
    uint32_t duty;
    uint32_t threshold;
    bool active;
} machine_pwm_obj_t;

static uint32_t pwm_tick_counter = 0;

static void update_timer_freq(uint32_t freq) {
    if (freq == 0) return;
    // Timer frequency = CPU_FREQ / (RELOAD + 1)
    // We want PWM frequency * PWM_RESOLUTION
    uint32_t reload = (CPU_FREQ / (freq * PWM_RESOLUTION)) - 1;
    TIMER1_RELOAD = reload;
}

void machine_pwm_tick(void) {
    pwm_tick_counter++;
    if (pwm_tick_counter >= PWM_RESOLUTION) {
        pwm_tick_counter = 0;
    }

    for (int i = 0; i < MAX_PWM; i++) {
        machine_pwm_obj_t *pwm = MP_STATE_PORT(active_pwm)[i];
        if (pwm && pwm->active) {
            if (pwm_tick_counter < pwm->threshold) {
                REG_DATAOUT |= (1 << pwm->pin_id);
            } else {
                REG_DATAOUT &= ~(1 << pwm->pin_id);
            }
        }
    }
}

static void machine_pwm_print(const mp_print_t *print, mp_obj_t self_in, mp_print_kind_t kind) {
    machine_pwm_obj_t *self = MP_OBJ_TO_PTR(self_in);
    mp_printf(print, "PWM(pin=%u, freq=%u, duty=%u)",
        (unsigned int)self->pin_id, (unsigned int)self->freq, (unsigned int)self->duty);
}

static mp_obj_t machine_pwm_init_helper(machine_pwm_obj_t *self, size_t n_args, const mp_obj_t *pos_args, mp_map_t *kw_args) {
    enum { ARG_freq, ARG_duty };
    static const mp_arg_t allowed_args[] = {
        { MP_QSTR_freq, MP_ARG_INT, {.u_int = -1} },
        { MP_QSTR_duty, MP_ARG_INT, {.u_int = -1} },
    };

    mp_arg_val_t vals[MP_ARRAY_SIZE(allowed_args)];
    mp_arg_parse_all(n_args, pos_args, kw_args, MP_ARRAY_SIZE(allowed_args), allowed_args, vals);

    if (vals[ARG_freq].u_int != -1) {
        self->freq = vals[ARG_freq].u_int;
    }
    if (vals[ARG_duty].u_int != -1) {
        self->duty = vals[ARG_duty].u_int;
        // duty is 0-1023 in some older MP, or duty_u16 0-65535.
        // Let's assume 0-1023 for now or scale if needed.
        // Actually MicroPython PWM duty is 0-1023.
        self->threshold = (self->duty * PWM_RESOLUTION) / 1024;
    }

    // Find a slot in active_pwm
    int slot = -1;
    for (int i = 0; i < MAX_PWM; i++) {
        if (MP_STATE_PORT(active_pwm)[i] == self) {
            slot = i;
            break;
        }
        if (slot == -1 && MP_STATE_PORT(active_pwm)[i] == NULL) {
            slot = i;
        }
    }

    if (slot != -1) {
        MP_STATE_PORT(active_pwm)[slot] = self;
        self->active = true;
    }

    // Start timer if not already running
    update_timer_freq(self->freq);
    TIMER1_CTRL = 0x09; // Enable, Interrupt Enable
    NVIC_ISER0 |= (1 << 9); // Enable IRQ 9 (TIMER1)

    return mp_const_none;
}

static mp_obj_t machine_pwm_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    mp_arg_check_num(n_args, n_kw, 1, MP_OBJ_FUN_ARGS_MAX, true);

    // Pin should be passed as the first argument
    uint32_t pin_id;
    if (mp_obj_is_type(args[0], &machine_pin_type)) {
        machine_pin_obj_t *pin = MP_OBJ_TO_PTR(args[0]);
        pin_id = pin->pin_id;
    } else {
        pin_id = mp_obj_get_int(args[0]);
    }

    if (pin_id >= 16) {
        mp_raise_ValueError(MP_ERROR_TEXT("invalid pin"));
    }

    machine_pwm_obj_t *self = mp_obj_malloc(machine_pwm_obj_t, &machine_pwm_type);
    self->base.type = &machine_pwm_type;
    self->pin_id = pin_id;
    self->freq = 1000;
    self->duty = 512;
    self->threshold = (self->duty * PWM_RESOLUTION) / 1024;
    self->active = false;

    // Set pin to output and clear alt func
    REG_OUTENSET = (1 << self->pin_id);
    REG_ALTFUNCCLR = (1 << self->pin_id);

    if (n_args > 1 || n_kw > 0) {
        // Handle PWM initialization
        mp_map_t kw_args;
        mp_map_init_fixed_table(&kw_args, n_kw, args + n_args);
        machine_pwm_init_helper(self, n_args - 1, args + 1, &kw_args);
    }

    return MP_OBJ_FROM_PTR(self);
}

static mp_obj_t machine_pwm_init(size_t n_args, const mp_obj_t *args, mp_map_t *kw_args) {
    return machine_pwm_init_helper(MP_OBJ_TO_PTR(args[0]), n_args - 1, args + 1, kw_args);
}
static MP_DEFINE_CONST_FUN_OBJ_KW(machine_pwm_init_obj, 1, machine_pwm_init);

static mp_obj_t machine_pwm_deinit(mp_obj_t self_in) {
    machine_pwm_obj_t *self = MP_OBJ_TO_PTR(self_in);
    self->active = false;
    for (int i = 0; i < MAX_PWM; i++) {
        if (MP_STATE_PORT(active_pwm)[i] == self) {
            MP_STATE_PORT(active_pwm)[i] = NULL;
            break;
        }
    }
    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_1(machine_pwm_deinit_obj, machine_pwm_deinit);

static mp_obj_t machine_pwm_freq(size_t n_args, const mp_obj_t *args) {
    machine_pwm_obj_t *self = MP_OBJ_TO_PTR(args[0]);
    if (n_args == 1) {
        return MP_OBJ_NEW_SMALL_INT(self->freq);
    } else {
        self->freq = mp_obj_get_int(args[1]);
        update_timer_freq(self->freq);
        return mp_const_none;
    }
}
static MP_DEFINE_CONST_FUN_OBJ_VAR_BETWEEN(machine_pwm_freq_obj, 1, 2, machine_pwm_freq);

static mp_obj_t machine_pwm_duty(size_t n_args, const mp_obj_t *args) {
    machine_pwm_obj_t *self = MP_OBJ_TO_PTR(args[0]);
    if (n_args == 1) {
        return MP_OBJ_NEW_SMALL_INT(self->duty);
    } else {
        self->duty = mp_obj_get_int(args[1]);
        self->threshold = (self->duty * PWM_RESOLUTION) / 1024;
        return mp_const_none;
    }
}
static MP_DEFINE_CONST_FUN_OBJ_VAR_BETWEEN(machine_pwm_duty_obj, 1, 2, machine_pwm_duty);

static const mp_rom_map_elem_t machine_pwm_locals_dict_table[] = {
    { MP_ROM_QSTR(MP_QSTR_init), MP_ROM_PTR(&machine_pwm_init_obj) },
    { MP_ROM_QSTR(MP_QSTR_deinit), MP_ROM_PTR(&machine_pwm_deinit_obj) },
    { MP_ROM_QSTR(MP_QSTR_freq), MP_ROM_PTR(&machine_pwm_freq_obj) },
    { MP_ROM_QSTR(MP_QSTR_duty), MP_ROM_PTR(&machine_pwm_duty_obj) },
};
static MP_DEFINE_CONST_DICT(machine_pwm_locals_dict, machine_pwm_locals_dict_table);

MP_DEFINE_CONST_OBJ_TYPE(
    machine_pwm_type,
    MP_QSTR_PWM,
    MP_TYPE_FLAG_NONE,
    make_new, machine_pwm_make_new,
    print, machine_pwm_print,
    locals_dict, &machine_pwm_locals_dict
);
