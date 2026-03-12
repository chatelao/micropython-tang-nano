/* mphalport.c */
#include "py/stream.h"
#include "py/runtime.h"
#include "mphalport.h"
#include "uart.h"
#include "pin.h"
#include "timer.h"

#define SYSTICK_BASE 0xE000E010
#define SYSTICK_CTRL (*(volatile uint32_t *)(SYSTICK_BASE + 0x00))
#define SYSTICK_LOAD (*(volatile uint32_t *)(SYSTICK_BASE + 0x04))
#define SYSTICK_VAL  (*(volatile uint32_t *)(SYSTICK_BASE + 0x08))

#define SCB_VTOR (*(volatile uint32_t *)0xE000ED08)

volatile mp_uint_t ticks_ms = 0;

extern const uint32_t isr_vector[];

void mp_hal_init(void) {
    // Set VTOR to the start of the interrupt vector table
    SCB_VTOR = (uint32_t)isr_vector;

    uart_init(115200);
    pin_init();

    // Configure SysTick for 1ms interrupts
    SYSTICK_LOAD = (CPU_FREQ / 1000) - 1;
    SYSTICK_VAL = 0;
    SYSTICK_CTRL = 0x07; // Enable, Source=Processor, Interrupt=Enable

    // Enable global interrupts
    __asm__ volatile ("cpsie i");
}

void SysTick_Handler(void) {
    ticks_ms++;
    machine_timer_tick_all();
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
    uint32_t irq_state = disable_irq();
    uint32_t counter = SYSTICK_VAL;
    uint32_t milliseconds = ticks_ms;
    uint32_t status = SYSTICK_CTRL;
    enable_irq(irq_state);

    if (status & (1 << 16)) {
        milliseconds++;
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
    // Pure cycle-based delay for maximum stability in simulation
    uint32_t cycles_per_us = CPU_FREQ / 1000000;
    for (volatile uint32_t i = 0; i < us * cycles_per_us / 4; i++) {
        __asm__("nop");
    }
}
