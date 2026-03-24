/* mphalport.h */
#ifndef MPHALPORT_H
#define MPHALPORT_H

#include <stdint.h>
#include "py/mpconfig.h"
#include "py/objtype.h"

void mp_hal_init(void);
mp_uint_t mp_hal_stdout_tx_strn(const char *str, size_t len);
int mp_hal_stdin_rx_chr(void);
static inline void mp_hal_set_interrupt_char(int c) {}
void mp_hal_delay_ms(mp_uint_t ms);
void mp_hal_delay_us(mp_uint_t us);
#define mp_hal_delay_us_fast(us) mp_hal_delay_us(us)
mp_uint_t mp_hal_ticks_ms(void);
mp_uint_t mp_hal_ticks_us(void);
mp_uint_t mp_hal_ticks_cpu(void);

static inline mp_uint_t disable_irq(void) {
    uint32_t state;
    __asm__ volatile ("mrs %0, primask" : "=r" (state));
    __asm__ volatile ("cpsid i");
    return state;
}

static inline void enable_irq(mp_uint_t state) {
    __asm__ volatile ("msr primask, %0" : : "r" (state));
}

static inline void mp_hal_wfi(void) {
    __asm__ volatile ("wfi");
}

#include "extmod/virtpin.h"

#define mp_hal_pin_obj_t mp_obj_t
#define mp_hal_get_pin_obj(o) (o)

static inline mp_uint_t mp_hal_pin_ioctl(mp_obj_t pin, mp_uint_t request, uintptr_t arg, int *errcode) {
    const mp_pin_p_t *proto = (const mp_pin_p_t *)MP_OBJ_TYPE_GET_SLOT(mp_obj_get_type(pin), protocol);
    if (proto && proto->ioctl) {
        return proto->ioctl(pin, request, arg, errcode);
    }
    return -1;
}

#define mp_hal_pin_read(p) mp_virtual_pin_read(p)
#define mp_hal_pin_write(p, v) mp_virtual_pin_write(p, v)
#define mp_hal_pin_high(p) mp_virtual_pin_write(p, 1)
#define mp_hal_pin_low(p) mp_virtual_pin_write(p, 0)

#define mp_hal_pin_input(p) mp_hal_pin_ioctl(p, MP_PIN_INPUT, 0, NULL)
#define mp_hal_pin_output(p) mp_hal_pin_ioctl(p, MP_PIN_OUTPUT, 0, NULL)
#define mp_hal_pin_od_low(p) { mp_hal_pin_low(p); mp_hal_pin_output(p); }
#define mp_hal_pin_od_high(p) mp_hal_pin_input(p)
#define mp_hal_pin_open_drain(p) // Virtual pin protocol handles this via ioctl
#define mp_hal_pin_name(p) (p)

#define MP_HAL_PIN_FMT "%p"

#endif
