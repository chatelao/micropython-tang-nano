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

    // Enable global interrupts
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
    uint32_t irq_state = disable_irq();
    uint32_t counter = SYSTICK_VAL;
    uint32_t milliseconds = ticks_ms;
    uint32_t status = SYSTICK_CTRL;
    enable_irq(irq_state);

    // Check if SysTick interrupt is pending (COUNTFLAG set)
    // If it is, then milliseconds might be one behind.
    if (status & (1 << 16)) {
        milliseconds++;
        // Read counter again in case it wrapped just as we read status
        counter = SYSTICK_VAL;
    }

    uint32_t load = SYSTICK_LOAD + 1;
    uint32_t us_per_tick = CPU_FREQ / 1000000;
    return milliseconds * 1000 + (load - counter) / us_per_tick;
}

mp_uint_t mp_hal_ticks_cpu(void) {
    return mp_hal_ticks_us() * (CPU_FREQ / 1000000);
}

void mp_hal_delay_us(mp_uint_t us) {
    uint32_t start = mp_hal_ticks_us();
    while (mp_hal_ticks_us() - start < us) {
        mp_handle_pending(true);
    }
}
