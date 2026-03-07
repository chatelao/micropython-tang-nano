/* mphalport.c */
#include "py/stream.h"
#include "mphalport.h"
#include "uart.h"
#include "pin.h"

void mp_hal_init(void) {
    uart_init(115200);
    pin_init();
}

mp_uint_t mp_hal_stdout_tx_strn(const char *str, size_t len) {
    for (size_t i = 0; i < len; i++) {
        uart_tx_char(str[i]);
    }
    return len;
}

int mp_hal_stdin_rx_chr(void) {
    return uart_rx_char();
}

void mp_hal_delay_ms(mp_uint_t ms) {
    // Simple delay loop for now
    for (volatile uint32_t i = 0; i < ms * 1000; i++) {
        __asm__("nop");
    }
}

mp_uint_t mp_hal_ticks_ms(void) {
    // Return 0 as no timer is implemented yet
    return 0;
}
