/* dma.c */
#include <stdint.h>
#include <string.h>
#include "py/runtime.h"
#include "dma.h"

// Minimal implementation for the MicroPython FPGADMA object
typedef struct _machine_fpga_dma_obj_t {
    mp_obj_base_t base;
} machine_fpga_dma_obj_t;

static mp_obj_t machine_fpga_dma_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    static machine_fpga_dma_obj_t self;
    self.base.type = &machine_fpga_dma_type;
    return MP_OBJ_FROM_PTR(&self);
}

static mp_obj_t machine_fpga_dma_transfer(size_t n_args, const mp_obj_t *args) {
    // transfer(src, dest, size)
    // For simplicity, we accept:
    // src: int (address) or buffer
    // dest: int (address) or buffer
    // size: int

    uint32_t src_addr;
    uint32_t dest_addr;
    uint32_t length = mp_obj_get_int(args[3]);

    mp_buffer_info_t src_bufinfo;
    if (mp_get_buffer(args[1], &src_bufinfo, MP_BUFFER_READ)) {
        src_addr = (uint32_t)src_bufinfo.buf;
    } else {
        src_addr = mp_obj_get_int(args[1]);
    }

    mp_buffer_info_t dest_bufinfo;
    if (mp_get_buffer(args[2], &dest_bufinfo, MP_BUFFER_WRITE)) {
        dest_addr = (uint32_t)dest_bufinfo.buf;
    } else {
        dest_addr = mp_obj_get_int(args[2]);
    }

    // Update hardware registers
    DMA0->SRC = src_addr;
    DMA0->DST = dest_addr;
    DMA0->LEN = length;
    DMA0->CTRL |= DMA_CTRL_START | DMA_CTRL_BUSY;

    // For simulation, perform the transfer immediately using memcpy
    memcpy((void *)dest_addr, (void *)src_addr, length);

    // Update hardware registers to indicate completion
    DMA0->CTRL &= ~DMA_CTRL_BUSY;
    DMA0->CTRL |= DMA_CTRL_DONE;

    return mp_const_none;
}
static MP_DEFINE_CONST_FUN_OBJ_VAR_BETWEEN(machine_fpga_dma_transfer_obj, 4, 4, machine_fpga_dma_transfer);

static const mp_rom_map_elem_t machine_fpga_dma_locals_dict_table[] = {
    { MP_ROM_QSTR(MP_QSTR_transfer), MP_ROM_PTR(&machine_fpga_dma_transfer_obj) },
};
static MP_DEFINE_CONST_DICT(machine_fpga_dma_locals_dict, machine_fpga_dma_locals_dict_table);

MP_DEFINE_CONST_OBJ_TYPE(
    machine_fpga_dma_type,
    MP_QSTR_FPGADMA,
    MP_TYPE_FLAG_NONE,
    make_new, machine_fpga_dma_make_new,
    locals_dict, &machine_fpga_dma_locals_dict
    );
