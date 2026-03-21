#include <stdint.h>
#include "py/runtime.h"
#include "py/mphal.h"
#include "extmod/virtpin.h"
#include "pin.h"

#define GPIO_BASE (0x40010000)
#define GPIO_REG(off) (*(volatile uint32_t *)(GPIO_BASE + (off)))

#define REG_DATA         GPIO_REG(0x0000)
#define REG_DATAOUT      GPIO_REG(0x0004)
#define REG_OUTENSET     GPIO_REG(0x0010)
#define REG_OUTENCLR     GPIO_REG(0x0014)
#define REG_ALTFUNCSET   GPIO_REG(0x0018)
#define REG_ALTFUNCCLR   GPIO_REG(0x001C)
#define REG_INTENSET     GPIO_REG(0x0020)
#define REG_INTENCLR     GPIO_REG(0x0024)
#define REG_INTTYPESET   GPIO_REG(0x0028)
#define REG_INTTYPECLR   GPIO_REG(0x002C)
#define REG_INTPOLSET    GPIO_REG(0x0030)
#define REG_INTPOLCLR    GPIO_REG(0x0034)
#define REG_INTSTATUS    GPIO_REG(0x0038)

#define NVIC_ISER0 (*(volatile uint32_t *)(0xE000E100))

MP_REGISTER_ROOT_POINTER(mp_obj_t pin_irq_handler[16]);
MP_REGISTER_ROOT_POINTER(struct _machine_pin_obj_t *pin_obj[16]);

void pin_init(void) {
    // Initialize GPIO if needed (e.g., clear all output enables)
    REG_OUTENCLR = 0xFFFF;
}

static void machine_pin_print(const mp_print_t *print, mp_obj_t self_in, mp_print_kind_t kind) {
    machine_pin_obj_t *self = MP_OBJ_TO_PTR(self_in);
    mp_printf(print, "Pin(%u)", (unsigned int)self->pin_id);
}

static mp_obj_t machine_pin_init_helper(machine_pin_obj_t *self, size_t n_args, const mp_obj_t *args, mp_map_t *kw_args) {
    enum { ARG_mode, ARG_pull, ARG_value };
    static const mp_arg_t allowed_args[] = {
        { MP_QSTR_mode, MP_ARG_INT, {.u_int = -1} },
        { MP_QSTR_pull, MP_ARG_INT, {.u_int = -1} },
        { MP_QSTR_value, MP_ARG_OBJ, {.u_obj = MP_OBJ_NULL} },
    };

    mp_arg_val_t vals[MP_ARRAY_SIZE(allowed_args)];
    mp_arg_parse_all(n_args, args, kw_args, MP_ARRAY_SIZE(allowed_args), allowed_args, vals);

    // Simple mode handling: 0=IN, 1=OUT (typical for minimal ports)
    if (vals[ARG_mode].u_int == 0) {
        REG_OUTENCLR = (1 << self->pin_id);
        REG_ALTFUNCCLR = (1 << self->pin_id);
    } else if (vals[ARG_mode].u_int == 1) {
        REG_OUTENSET = (1 << self->pin_id);
        REG_ALTFUNCCLR = (1 << self->pin_id);
    }

    if (vals[ARG_value].u_obj != MP_OBJ_NULL) {
        if (mp_obj_is_true(vals[ARG_value].u_obj)) {
            REG_DATAOUT |= (1 << self->pin_id);
        } else {
            REG_DATAOUT &= ~(1 << self->pin_id);
        }
    }

    return mp_const_none;
}

static mp_obj_t machine_pin_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    mp_arg_check_num(n_args, n_kw, 1, MP_OBJ_FUN_ARGS_MAX, true);

    uint32_t pin_id = mp_obj_get_int(args[0]);
    if (pin_id >= 16) {
        mp_raise_ValueError(MP_ERROR_TEXT("invalid pin"));
    }

    machine_pin_obj_t *self = MP_STATE_PORT(pin_obj)[pin_id];
    if (self == NULL) {
        self = mp_obj_malloc(machine_pin_obj_t, &machine_pin_type);
        self->base.type = &machine_pin_type;
        self->pin_id = pin_id;
        MP_STATE_PORT(pin_obj)[pin_id] = self;
    }

    if (n_args > 1 || n_kw > 0) {
        // Handle pin initialization
        mp_map_t kw_args;
        mp_map_init_fixed_table(&kw_args, n_kw, args + n_args);
        machine_pin_init_helper(self, n_args - 1, args + 1, &kw_args);
    }

    return MP_OBJ_FROM_PTR(self);
}

static mp_obj_t machine_pin_value(size_t n_args, const mp_obj_t *args) {
    machine_pin_obj_t *self = MP_OBJ_TO_PTR(args[0]);
    if (n_args == 1) {
        // Get value
        return MP_OBJ_NEW_SMALL_INT((REG_DATA >> self->pin_id) & 1);
    } else {
        // Set value
        if (mp_obj_is_true(args[1])) {
            REG_DATAOUT |= (1 << self->pin_id);
        } else {
            REG_DATAOUT &= ~(1 << self->pin_id);
        }
        return mp_const_none;
    }
}
static MP_DEFINE_CONST_FUN_OBJ_VAR_BETWEEN(machine_pin_value_obj, 1, 2, machine_pin_value);

static mp_obj_t machine_pin_off(mp_obj_t self_in) {
    machine_pin_obj_t *self = MP_OBJ_TO_PTR(self_in);
    REG_DATAOUT &= ~(1 << self->pin_id);
    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_1(machine_pin_off_obj, machine_pin_off);

static mp_obj_t machine_pin_on(mp_obj_t self_in) {
    machine_pin_obj_t *self = MP_OBJ_TO_PTR(self_in);
    REG_DATAOUT |= (1 << self->pin_id);
    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_1(machine_pin_on_obj, machine_pin_on);

static mp_obj_t machine_pin_init(size_t n_args, const mp_obj_t *args, mp_map_t *kw_args) {
    return machine_pin_init_helper(MP_OBJ_TO_PTR(args[0]), n_args - 1, args + 1, kw_args);
}
static MP_DEFINE_CONST_FUN_OBJ_KW(machine_pin_init_obj, 1, machine_pin_init);

static mp_uint_t machine_pin_ioctl(mp_obj_t self_in, mp_uint_t request, uintptr_t arg, int *errcode) {
    machine_pin_obj_t *self = MP_OBJ_TO_PTR(self_in);

    switch (request) {
        case MP_PIN_READ: {
            return (REG_DATA >> self->pin_id) & 1;
        }
        case MP_PIN_WRITE: {
            if (arg) {
                REG_DATAOUT |= (1 << self->pin_id);
            } else {
                REG_DATAOUT &= ~(1 << self->pin_id);
            }
            return 0;
        }
        case MP_PIN_INPUT: {
            REG_OUTENCLR = (1 << self->pin_id);
            return 0;
        }
        case MP_PIN_OUTPUT: {
            REG_OUTENSET = (1 << self->pin_id);
            return 0;
        }
    }
    return -1;
}

static const mp_pin_p_t machine_pin_protocol = {
    .ioctl = machine_pin_ioctl,
};

static mp_obj_t machine_pin_irq(size_t n_args, const mp_obj_t *pos_args, mp_map_t *kw_args) {
    enum { ARG_handler, ARG_trigger, ARG_hard };
    static const mp_arg_t allowed_args[] = {
        { MP_QSTR_handler, MP_ARG_OBJ, {.u_obj = mp_const_none} },
        { MP_QSTR_trigger, MP_ARG_INT, {.u_int = 3} }, // 3 = Rising | Falling (default)
        { MP_QSTR_hard, MP_ARG_BOOL, {.u_bool = false} },
    };

    machine_pin_obj_t *self = MP_OBJ_TO_PTR(pos_args[0]);
    mp_arg_val_t vals[MP_ARRAY_SIZE(allowed_args)];
    mp_arg_parse_all(n_args - 1, pos_args + 1, kw_args, MP_ARRAY_SIZE(allowed_args), allowed_args, vals);

    if (vals[ARG_handler].u_obj == mp_const_none) {
        // Disable interrupt
        REG_INTENCLR = (1 << self->pin_id);
        MP_STATE_PORT(pin_irq_handler)[self->pin_id] = mp_const_none;
    } else {
        // Configure interrupt
        MP_STATE_PORT(pin_irq_handler)[self->pin_id] = vals[ARG_handler].u_obj;

        uint32_t trigger = vals[ARG_trigger].u_int;

        // In CMSDK GPIO:
        // INTTYPESET/CLR: 0 = level, 1 = edge
        // INTPOLSET/CLR: 0 = low/falling, 1 = high/rising
        // Note: CMSDK GPIO typically supports only one edge at a time if implemented strictly.
        // We'll follow IPUG931 which says:
        // [15:0] Interrupt type set: 0 for LOW/HIGH level, 1 for falling edge or rising edge
        // [15:0] Polarity: 0 for LOW level or falling edge, 1 for HIGH level or rising edge

        REG_INTTYPESET = (1 << self->pin_id); // Edge triggered
        if (trigger & 1) { // Rising
            REG_INTPOLSET = (1 << self->pin_id);
        } else { // Falling
            REG_INTPOLCLR = (1 << self->pin_id);
        }

        REG_INTSTATUS = (1 << self->pin_id); // Clear pending
        REG_INTENSET = (1 << self->pin_id);  // Enable interrupt

        // Enable IRQ in NVIC (IRQ 16 + pin_id)
        NVIC_ISER0 |= (1 << (16 + self->pin_id));
    }

    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_KW(machine_pin_irq_obj, 1, machine_pin_irq);

void machine_pin_dispatch_irq(uint32_t pin_id) {
    if (pin_id < 16) {
        mp_obj_t handler = MP_STATE_PORT(pin_irq_handler)[pin_id];
        if (handler != mp_const_none) {
            machine_pin_obj_t *self = MP_STATE_PORT(pin_obj)[pin_id];
            if (self != NULL) {
                mp_sched_schedule(handler, MP_OBJ_FROM_PTR(self));
            }
        }
    }
}

static const mp_rom_map_elem_t machine_pin_locals_dict_table[] = {
    { MP_ROM_QSTR(MP_QSTR_init), MP_ROM_PTR(&machine_pin_init_obj) },
    { MP_ROM_QSTR(MP_QSTR_value), MP_ROM_PTR(&machine_pin_value_obj) },
    { MP_ROM_QSTR(MP_QSTR_off), MP_ROM_PTR(&machine_pin_off_obj) },
    { MP_ROM_QSTR(MP_QSTR_on), MP_ROM_PTR(&machine_pin_on_obj) },
    { MP_ROM_QSTR(MP_QSTR_irq), MP_ROM_PTR(&machine_pin_irq_obj) },

    { MP_ROM_QSTR(MP_QSTR_IN), MP_ROM_INT(0) },
    { MP_ROM_QSTR(MP_QSTR_OUT), MP_ROM_INT(1) },
    { MP_ROM_QSTR(MP_QSTR_IRQ_RISING), MP_ROM_INT(1) },
    { MP_ROM_QSTR(MP_QSTR_IRQ_FALLING), MP_ROM_INT(2) },
};
static MP_DEFINE_CONST_DICT(machine_pin_locals_dict, machine_pin_locals_dict_table);

MP_DEFINE_CONST_OBJ_TYPE(
    machine_pin_type,
    MP_QSTR_Pin,
    MP_TYPE_FLAG_NONE,
    make_new, machine_pin_make_new,
    print, machine_pin_print,
    protocol, &machine_pin_protocol,
    locals_dict, &machine_pin_locals_dict
    );
