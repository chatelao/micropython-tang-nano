#ifndef MICROPY_INCLUDED_TANG_NANO_4K_BRIDGE_H
#define MICROPY_INCLUDED_TANG_NANO_4K_BRIDGE_H

#include <stdint.h>
#include "py/obj.h"

// GPIO AHB Bridge (16-bit)
#define FPGA_GPIO_BASE      (0x40010000)
#define FPGA_GPIO_DATA      (*(volatile uint32_t *)(FPGA_GPIO_BASE + 0x00))
#define FPGA_GPIO_OUTENSET  (*(volatile uint32_t *)(FPGA_GPIO_BASE + 0x10))
#define FPGA_GPIO_OUTENCLR  (*(volatile uint32_t *)(FPGA_GPIO_BASE + 0x14))

// APB2 Expansion Slots
#define FPGA_APB2_SLOT_BASE(n) (0x40002400 + ((n-1) * 0x100))

typedef struct _machine_fpga_bridge_obj_t {
    mp_obj_base_t base;
} machine_fpga_bridge_obj_t;

extern const mp_obj_type_t machine_fpga_bridge_type;

void bridge_init(void);

#endif // MICROPY_INCLUDED_TANG_NANO_4K_BRIDGE_H
