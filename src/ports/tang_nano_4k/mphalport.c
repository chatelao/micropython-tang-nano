/* mphalport.c */
#include "py/stream.h"
#include "mphalport.h"

void mp_hal_init(void) {
    // UART init
}

void mp_hal_stdout_tx_strn(const char *str, mp_uint_t len) {
    // UART tx
}

int mp_hal_stdin_rx_chr(void) {
    // UART rx
    return 0;
}

void mp_hal_delay_ms(mp_uint_t ms) {
}

mp_uint_t mp_hal_ticks_ms(void) {
    return 0;
}
