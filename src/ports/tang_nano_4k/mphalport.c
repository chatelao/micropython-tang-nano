/* mphalport.c */
#include "py/stream.h"
#include "py/runtime.h"
#include "mphalport.h"
#include "uart.h"
#include "pin.h"

#define SYSTICK_BASE 0xE000E010
#define SYSTICK_CTRL (*(volatile uint32_t *)(SYSTICK_BASE + 0x00))
#define SYSTICK_LOAD (*(volatile uint32_t *)(SYSTICK_BASE + 0x04))
#define SYSTICK_VAL  (*(volatile uint32_t *)(SYSTICK_BASE + 0x08))

volatile mp_uint_t ticks_ms = 0;

void mp_hal_init(void) {
    uart_init(115200);
    pin_init();

    // Configure SysTick for 1ms interrupts
    SYSTICK_LOAD = (CPU_FREQ / 1000) - 1;
    SYSTICK_VAL = 0;
    SYSTICK_CTRL = 0x07; // Enable, Source=Processor, Interrupt=Enable

    __asm__ volatile ("cpsie i");
}

mp_uint_t mp_hal_stdout_tx_strn(const char *str, size_t len) {
    for (size_t i = 0; i < len; i++) {
        uart_tx_char(str[i]);
    }
    return len;
}

int mp_hal_stdin_rx_chr(void) {
    for (;;) {
        int c = uart_rx_char_nonblocking();
        if (c != -1) {
            return c;
        }
        mp_handle_pending(true);
        __asm__("wfi");
    }
}

void mp_hal_delay_ms(mp_uint_t ms) {
    uint32_t start = mp_hal_ticks_ms();
    while (mp_hal_ticks_ms() - start < ms) {
        mp_handle_pending(true);
        __asm__("wfi");
    }
}

mp_uint_t mp_hal_ticks_ms(void) {
    return ticks_ms;
}

mp_uint_t mp_hal_ticks_us(void) {
    uint32_t load = SYSTICK_LOAD;
    uint32_t ms = ticks_ms;
    uint32_t val = SYSTICK_VAL;
    if (SYSTICK_CTRL & (1 << 16)) {
        ms = ticks_ms;
        val = SYSTICK_VAL;
    }
    return ms * 1000 + (load - val) / (CPU_FREQ / 1000000);
}

mp_uint_t mp_hal_ticks_cpu(void) {
    uint32_t load = SYSTICK_LOAD;
    uint32_t ms = ticks_ms;
    uint32_t val = SYSTICK_VAL;
    if (SYSTICK_CTRL & (1 << 16)) {
        ms = ticks_ms;
        val = SYSTICK_VAL;
    }
    return ms * (load + 1) + (load - val);
}

void mp_hal_delay_us(mp_uint_t us) {
    // Assuming CPU_FREQ is in Hz, calculate cycles per us
    uint32_t cycles_per_us = CPU_FREQ / 1000000;
    for (volatile uint32_t i = 0; i < us * cycles_per_us / 4; i++) {
        __asm__("nop");
    }
}
