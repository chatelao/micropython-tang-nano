#ifndef MICROPY_INCLUDED_TANG_NANO_4K_TIMER_H
#define MICROPY_INCLUDED_TANG_NANO_4K_TIMER_H

#include "py/obj.h"

extern const mp_obj_type_t machine_timer_type;

void machine_timer_tick_all(void);

#endif // MICROPY_INCLUDED_TANG_NANO_4K_TIMER_H
