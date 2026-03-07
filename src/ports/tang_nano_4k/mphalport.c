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
    }
}

void mp_hal_delay_ms(mp_uint_t ms) {
    uint32_t start = mp_hal_ticks_ms();
    while (mp_hal_ticks_ms() - start < ms) {
        mp_handle_pending(true);
    }
}

mp_uint_t mp_hal_ticks_ms(void) {
    return ticks_ms;
}

mp_uint_t mp_hal_ticks_us(void) {
    return ticks_ms * 1000;
}

mp_uint_t mp_hal_ticks_cpu(void) {
    return ticks_ms * 1000;
}

void mp_hal_delay_us(mp_uint_t us) {
    // Basic busy-wait for us delay
    // 27MHz = 27 cycles per us.
    // Each loop iteration takes some cycles.
    // 27 cycles is roughly 9 iterations if each loop is 3 cycles.
    // Let's use a safe approximation for now.
    volatile uint32_t count = us * (CPU_FREQ / 4000000); // Very rough
    while (count--) {
        __asm__("nop");
    }
}
