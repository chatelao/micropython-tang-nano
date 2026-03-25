#include <stdint.h>
#include "py/runtime.h"
#include "bridge.h"

void bridge_init(void) {
    // Enable all bits of the GPIO bridge as outputs to the FPGA by default
    FPGA_GPIO_OUTENSET = 0xFFFF;
}

// Minimal implementation for the MicroPython FPGABridge object
static mp_obj_t machine_fpga_bridge_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    static machine_fpga_bridge_obj_t self;
    self.base.type = &machine_fpga_bridge_type;
    return MP_OBJ_FROM_PTR(&self);
}

static mp_obj_t machine_fpga_bridge_write(mp_obj_t self_in, mp_obj_t val_in) {
    uint32_t val = mp_obj_get_int(val_in);
    FPGA_GPIO_DATA = (uint16_t)val;
    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_2(machine_fpga_bridge_write_obj, machine_fpga_bridge_write);

static mp_obj_t machine_fpga_bridge_read(mp_obj_t self_in) {
    return MP_OBJ_NEW_SMALL_INT(FPGA_GPIO_DATA & 0xFFFF);
}
static MP_DEFINE_CONST_FUN_OBJ_1(machine_fpga_bridge_read_obj, machine_fpga_bridge_read);

static const mp_rom_map_elem_t machine_fpga_bridge_locals_dict_table[] = {
    { MP_ROM_QSTR(MP_QSTR_write), MP_ROM_PTR(&machine_fpga_bridge_write_obj) },
    { MP_ROM_QSTR(MP_QSTR_read), MP_ROM_PTR(&machine_fpga_bridge_read_obj) },
};
static MP_DEFINE_CONST_DICT(machine_fpga_bridge_locals_dict, machine_fpga_bridge_locals_dict_table);

MP_DEFINE_CONST_OBJ_TYPE(
    machine_fpga_bridge_type,
    MP_QSTR_FPGABridge,
    MP_TYPE_FLAG_NONE,
    make_new, machine_fpga_bridge_make_new,
    locals_dict, &machine_fpga_bridge_locals_dict
    );
