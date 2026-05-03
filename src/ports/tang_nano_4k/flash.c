#include <stdint.h>
#include <string.h>
#include "py/runtime.h"
#include "py/mperrno.h"
#include "extmod/vfs.h"
#include "flash.h"

// For simulation, we use the external flash mapped at 0xA0000000.
// To avoid corrupting any potential firmware, we start at a 1MB offset.
// In SPLIT_FLASH mode, we use the first 256KB for code, so we can start the FS at 256KB.
#define FLASH_BASE_ADDR      (0xA0000000)
#ifdef SPLIT_FLASH
#define FS_OFFSET            (0x40000)  // 256KB offset
#else
#define FS_OFFSET            (0x100000) // 1MB offset
#endif
#define FS_START_ADDR        (FLASH_BASE_ADDR + FS_OFFSET)

#define FLASH_BLOCK_SIZE     (4096)
#define FLASH_SECTOR_SIZE    (4096)
#define FLASH_SIZE           (4 * 1024 * 1024) // 4MB total external flash
#define FS_SIZE              (FLASH_SIZE - FS_OFFSET) // 3MB for filesystem

machine_flash_obj_t machine_flash_obj = {
    .base = { &machine_flash_type }
};

void flash_init(void) {
    // Initialization code if needed (e.g. for real hardware SPI Flash)
}

static mp_obj_t machine_flash_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    mp_arg_check_num(n_args, n_kw, 0, 0, false);
    return MP_OBJ_FROM_PTR(&machine_flash_obj);
}

static mp_obj_t machine_flash_readblocks(size_t n_args, const mp_obj_t *args) {
    uint32_t block_num = mp_obj_get_int(args[1]);
    mp_buffer_info_t bufinfo;
    mp_get_buffer_raise(args[2], &bufinfo, MP_BUFFER_WRITE);

    uint32_t offset = block_num * FLASH_BLOCK_SIZE;
    if (n_args == 4) {
        offset += mp_obj_get_int(args[3]);
    }

    if (offset + bufinfo.len > FS_SIZE) {
        mp_raise_OSError(MP_EIO);
    }

    memcpy(bufinfo.buf, (void *)(FS_START_ADDR + offset), bufinfo.len);

    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_VAR_BETWEEN(machine_flash_readblocks_obj, 3, 4, machine_flash_readblocks);

static mp_obj_t machine_flash_writeblocks(size_t n_args, const mp_obj_t *args) {
    uint32_t block_num = mp_obj_get_int(args[1]);
    mp_buffer_info_t bufinfo;
    mp_get_buffer_raise(args[2], &bufinfo, MP_BUFFER_READ);

    uint32_t offset = block_num * FLASH_BLOCK_SIZE;
    if (n_args == 4) {
        offset += mp_obj_get_int(args[3]);
    }

    if (offset + bufinfo.len > FS_SIZE) {
        mp_raise_OSError(MP_EIO);
    }

    // In simulation, we can just memcpy to the mapped memory.
    // On real hardware, we would need to call SPI Flash programming functions.
    memcpy((void *)(FS_START_ADDR + offset), bufinfo.buf, bufinfo.len);

    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_VAR_BETWEEN(machine_flash_writeblocks_obj, 3, 4, machine_flash_writeblocks);

static mp_obj_t machine_flash_ioctl(mp_obj_t self_in, mp_obj_t cmd_in, mp_obj_t arg_in) {
    mp_int_t cmd = mp_obj_get_int(cmd_in);
    switch (cmd) {
        case MP_BLOCKDEV_IOCTL_INIT:
            return MP_OBJ_NEW_SMALL_INT(0);
        case MP_BLOCKDEV_IOCTL_DEINIT:
            return MP_OBJ_NEW_SMALL_INT(0);
        case MP_BLOCKDEV_IOCTL_SYNC:
            return MP_OBJ_NEW_SMALL_INT(0);
        case MP_BLOCKDEV_IOCTL_BLOCK_COUNT:
            return MP_OBJ_NEW_SMALL_INT(FS_SIZE / FLASH_BLOCK_SIZE);
        case MP_BLOCKDEV_IOCTL_BLOCK_SIZE:
            return MP_OBJ_NEW_SMALL_INT(FLASH_BLOCK_SIZE);
        case MP_BLOCKDEV_IOCTL_BLOCK_ERASE: {
            uint32_t block_num = mp_obj_get_int(arg_in);
            uint32_t offset = block_num * FLASH_BLOCK_SIZE;
            if (offset >= FS_SIZE) {
                mp_raise_OSError(MP_EIO);
            }
            // In simulation, erase is just filling with 0xFF.
            memset((void *)(FS_START_ADDR + offset), 0xFF, FLASH_BLOCK_SIZE);
            return MP_OBJ_NEW_SMALL_INT(0);
        }
    }
    return mp_const_none;
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
