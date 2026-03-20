#include <stdint.h>
#include <string.h>

#include "py/runtime.h"
#include "py/mperrno.h"
#include "extmod/vfs.h"
#include "flash.h"

// External Flash mapped starting at 0x60000000
// We use an offset of 1MB to avoid overwriting the firmware
#define FLASH_BASE_ADDR      (0x60100000)
#define FLASH_BLOCK_SIZE     (4096)
#define FLASH_TOTAL_SIZE     (2 * 1024 * 1024)
#define FLASH_BLOCK_COUNT    (FLASH_TOTAL_SIZE / FLASH_BLOCK_SIZE)

typedef struct _machine_flash_obj_t {
    mp_obj_base_t base;
    uint32_t base_addr;
} machine_flash_obj_t;

static machine_flash_obj_t machine_flash_obj = {
    .base = { &machine_flash_type },
    .base_addr = FLASH_BASE_ADDR,
};

static mp_obj_t machine_flash_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    // There is only one flash peripheral for now
    return MP_OBJ_FROM_PTR(&machine_flash_obj);
}

static mp_obj_t machine_flash_readblocks(size_t n_args, const mp_obj_t *args) {
    // readblocks(block_num, buf, [offset])
    uint32_t block_num = mp_obj_get_int(args[1]);
    mp_buffer_info_t bufinfo;
    mp_get_buffer_raise(args[2], &bufinfo, MP_BUFFER_WRITE);

    uint32_t offset = 0;
    if (n_args == 4) {
        offset = mp_obj_get_int(args[3]);
    }

    uint8_t *dest = bufinfo.buf;
    uint8_t *src = (uint8_t *)(FLASH_BASE_ADDR + block_num * FLASH_BLOCK_SIZE + offset);
    memcpy(dest, src, bufinfo.len);

    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_VAR_BETWEEN(machine_flash_readblocks_obj, 3, 4, machine_flash_readblocks);

static mp_obj_t machine_flash_writeblocks(size_t n_args, const mp_obj_t *args) {
    // writeblocks(block_num, buf, [offset])
    uint32_t block_num = mp_obj_get_int(args[1]);
    mp_buffer_info_t bufinfo;
    mp_get_buffer_raise(args[2], &bufinfo, MP_BUFFER_READ);

    uint32_t offset = 0;
    if (n_args == 4) {
        offset = mp_obj_get_int(args[3]);
    }

    uint8_t *dest = (uint8_t *)(FLASH_BASE_ADDR + block_num * FLASH_BLOCK_SIZE + offset);
    uint8_t *src = bufinfo.buf;

    // In simulation, we can just memcpy
    memcpy(dest, src, bufinfo.len);

    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_VAR_BETWEEN(machine_flash_writeblocks_obj, 3, 4, machine_flash_writeblocks);

static mp_obj_t machine_flash_ioctl(mp_obj_t self_in, mp_obj_t op_in, mp_obj_t arg_in) {
    mp_int_t op = mp_obj_get_int(op_in);
    switch (op) {
        case MP_BLOCKDEV_IOCTL_INIT:
            return MP_OBJ_NEW_SMALL_INT(0); // success
        case MP_BLOCKDEV_IOCTL_DEINIT:
            return MP_OBJ_NEW_SMALL_INT(0); // success
        case MP_BLOCKDEV_IOCTL_SYNC:
            return MP_OBJ_NEW_SMALL_INT(0); // success
        case MP_BLOCKDEV_IOCTL_BLOCK_COUNT:
            return MP_OBJ_NEW_SMALL_INT(FLASH_BLOCK_COUNT);
        case MP_BLOCKDEV_IOCTL_BLOCK_SIZE:
            return MP_OBJ_NEW_SMALL_INT(FLASH_BLOCK_SIZE);
        case MP_BLOCKDEV_IOCTL_BLOCK_ERASE: {
            uint32_t block_num = mp_obj_get_int(arg_in);
            uint8_t *dest = (uint8_t *)(FLASH_BASE_ADDR + block_num * FLASH_BLOCK_SIZE);
            memset(dest, 0xFF, FLASH_BLOCK_SIZE);
            return MP_OBJ_NEW_SMALL_INT(0); // success
        }
        default:
            return mp_const_none;
    }
}
static MP_DEFINE_CONST_FUN_OBJ_3(machine_flash_ioctl_obj, machine_flash_ioctl);

static const mp_rom_map_elem_t machine_flash_locals_dict_table[] = {
    { MP_ROM_QSTR(MP_QSTR_readblocks), MP_ROM_PTR(&machine_flash_readblocks_obj) },
    { MP_ROM_QSTR(MP_QSTR_writeblocks), MP_ROM_PTR(&machine_flash_writeblocks_obj) },
    { MP_ROM_QSTR(MP_QSTR_ioctl), MP_ROM_PTR(&machine_flash_ioctl_obj) },
};
static MP_DEFINE_CONST_DICT(machine_flash_locals_dict, machine_flash_locals_dict_table);

MP_DEFINE_CONST_OBJ_TYPE(
    machine_flash_type,
    MP_QSTR_Flash,
    MP_TYPE_FLAG_NONE,
    make_new, machine_flash_make_new,
    locals_dict, &machine_flash_locals_dict
);

void flash_init_vfs(void) {
    // Mounting is usually done in main.c
}
