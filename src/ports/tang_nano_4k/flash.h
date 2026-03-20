#ifndef MICROPY_INCLUDED_TANG_NANO_4K_FLASH_H
#define MICROPY_INCLUDED_TANG_NANO_4K_FLASH_H

#include "py/obj.h"

extern const mp_obj_type_t machine_flash_type;

void flash_init_vfs(void);

#endif // MICROPY_INCLUDED_TANG_NANO_4K_FLASH_H
