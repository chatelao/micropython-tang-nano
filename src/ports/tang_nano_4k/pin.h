#ifndef MICROPY_INCLUDED_TANG_NANO_4K_PIN_H
#define MICROPY_INCLUDED_TANG_NANO_4K_PIN_H

#include "py/obj.h"

extern const mp_obj_type_t machine_pin_type;

typedef struct _machine_pin_obj_t {
    mp_obj_base_t base;
    uint32_t pin_id;
} machine_pin_obj_t;

void pin_init(void);

#endif // MICROPY_INCLUDED_TANG_NANO_4K_PIN_H
