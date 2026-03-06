/* mphalport.h */
#ifndef MPHALPORT_H
#define MPHALPORT_H

#include <stdint.h>
#include "py/mpconfig.h"

void mp_hal_init(void);
mp_uint_t mp_hal_stdout_tx_strn(const char *str, size_t len);
int mp_hal_stdin_rx_chr(void);
static inline void mp_hal_set_interrupt_char(int c) {}
void mp_hal_delay_ms(mp_uint_t ms);
mp_uint_t mp_hal_ticks_ms(void);

#endif
