#ifndef MICROPY_INCLUDED_TANG_NANO_4K_FLASH_H
#define MICROPY_INCLUDED_TANG_NANO_4K_FLASH_H

#include "py/obj.h"

typedef struct _machine_flash_obj_t {
    mp_obj_base_t base;
} machine_flash_obj_t;

extern const mp_obj_type_t machine_flash_type;
extern machine_flash_obj_t machine_flash_obj;

void flash_init(void);

#endif // MICROPY_INCLUDED_TANG_NANO_4K_FLASH_H
