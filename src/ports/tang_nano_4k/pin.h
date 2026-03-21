#ifndef MICROPY_INCLUDED_TANG_NANO_4K_PIN_H
#define MICROPY_INCLUDED_TANG_NANO_4K_PIN_H

#include "py/obj.h"

#define GPIO_BASE (0x40010000)
#define GPIO_REG(off) (*(volatile uint32_t *)(GPIO_BASE + (off)))

#define REG_DATA         GPIO_REG(0x0000)
#define REG_DATAOUT      GPIO_REG(0x0004)
#define REG_OUTENSET     GPIO_REG(0x0010)
#define REG_OUTENCLR     GPIO_REG(0x0014)
#define REG_ALTFUNCSET   GPIO_REG(0x0018)
#define REG_ALTFUNCCLR   GPIO_REG(0x001C)
#define REG_INTENSET     GPIO_REG(0x0020)
#define REG_INTENCLR     GPIO_REG(0x0024)
#define REG_INTTYPESET   GPIO_REG(0x0028)
#define REG_INTTYPECLR   GPIO_REG(0x002C)
#define REG_INTPOLSET    GPIO_REG(0x0030)
#define REG_INTPOLCLR    GPIO_REG(0x0034)
#define REG_INTSTATUS    GPIO_REG(0x0038)

#define NVIC_ISER0 (*(volatile uint32_t *)(0xE000E100))
#define NVIC_ICER0 (*(volatile uint32_t *)(0xE000E180))

extern const mp_obj_type_t machine_pin_type;

typedef struct _machine_pin_obj_t {
    mp_obj_base_t base;
    uint32_t pin_id;
} machine_pin_obj_t;

void pin_init(void);
void machine_pin_dispatch_irq(uint32_t pin_id);

#endif // MICROPY_INCLUDED_TANG_NANO_4K_PIN_H
