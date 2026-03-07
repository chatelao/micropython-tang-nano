/* mphalport.h */
#ifndef MPHALPORT_H
#define MPHALPORT_H

#include <stdint.h>
#include "py/mpconfig.h"
#include "py/obj.h"

typedef mp_obj_t mp_hal_pin_obj_t;

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

#define MP_HAL_PIN_FMT "Pin(%u)"
uint32_t mp_hal_pin_name(mp_hal_pin_obj_t p);

void mp_hal_pin_od_low(mp_hal_pin_obj_t pin);
void mp_hal_pin_od_high(mp_hal_pin_obj_t pin);
void mp_hal_pin_open_drain(mp_hal_pin_obj_t pin);

#endif
