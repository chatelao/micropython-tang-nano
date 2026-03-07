#ifndef MICROPY_INCLUDED_TANG_NANO_4K_PWM_H
#define MICROPY_INCLUDED_TANG_NANO_4K_PWM_H

#include "py/obj.h"

extern const mp_obj_type_t machine_pwm_type;

void machine_pwm_tick(void);

#endif // MICROPY_INCLUDED_TANG_NANO_4K_PWM_H
