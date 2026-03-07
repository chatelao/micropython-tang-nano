/* main.c */
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "py/builtin.h"
#include "py/compile.h"
#include "py/runtime.h"
#include "py/repl.h"
#include "py/gc.h"
#include "py/mperrno.h"
#include "py/stackctrl.h"
#include "shared/runtime/pyexec.h"
#include "mphalport.h"
#include "timer.h"
#include "pwm.h"

// Heap for MicroPython
static char heap[16 * 1024];
static char *stack_top;

int main(int argc, char **argv) {
    int stack_dummy;
    stack_top = (char *)&stack_dummy;
    mp_stack_set_limit(2048);

    gc_init(heap, heap + sizeof(heap));
    mp_init();
    mp_hal_init();
    printf("\nMicroPython started on Tang Nano 4K\n");

    for (;;) {
        if (pyexec_friendly_repl() != 0) {
            break;
        }
    }

    mp_deinit();
    return 0;
}

extern volatile mp_uint_t ticks_ms;
void SysTick_Handler(void) {
    ticks_ms++;
    machine_timer_tick_all();
}

#define TIMER1_INTCLEAR (*(volatile uint32_t *)(0x4000100C))
void TIMER1_Handler(void) {
    TIMER1_INTCLEAR = 1;
    machine_pwm_tick();
}

void gc_collect(void) {
    void *dummy;
    gc_collect_start();
    gc_collect_root(&dummy, ((mp_uint_t)stack_top - (mp_uint_t)&dummy) / sizeof(mp_uint_t));
    gc_collect_end();
}

mp_lexer_t *mp_lexer_new_from_file(qstr filename) {
    mp_raise_OSError(MP_ENOENT);
}

mp_import_stat_t mp_import_stat(const char *path) {
    return MP_IMPORT_STAT_NO_EXIST;
}

void nlr_jump_fail(void *val) {
    while (1);
}

void NORETURN __fatal_error(const char *msg) {
    while (1);
}

#ifndef NDEBUG
void MP_WEAK __assert_func(const char *file, int line, const char *func, const char *expr) {
    __fatal_error("Assertion failed");
}
#endif

// Cortex-M3 Startup Code
extern uint32_t _estack, _etext, _sdata, _edata, _sbss, _ebss;

void Reset_Handler(void) __attribute__((naked));
void Reset_Handler(void) {
    // set stack pointer
    __asm volatile ("ldr sp, =_estack");

    // Set VTOR to the start of isr_vector
    // Use the absolute address provided by FLASH_ORIGIN
    *(volatile uint32_t *)0xE000ED08 = FLASH_ORIGIN;

    // copy .data section from flash to RAM
    for (uint32_t *src = &_etext, *dest = &_sdata; dest < &_edata;) {
        *dest++ = *src++;
    }
    // zero out .bss section
    for (uint32_t *dest = &_sbss; dest < &_ebss;) {
        *dest++ = 0;
    }
    // jump to main
    main(0, NULL);
    for (;;);
}

const uint32_t isr_vector[] __attribute__((section(".isr_vector"), aligned(256))) = {
    (uint32_t)&_estack,
    (uint32_t)&Reset_Handler,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    (uint32_t)&SysTick_Handler,     // 0x3C
    0, // UART0_Handler             // 0x40
    0, // USER_INT0_Handler
    0, // UART1_Handler
    0, // USER_INT1_Handler
    0, // USER_INT2_Handler
    0, // Reserved
    0, // PORT0_COMB_Handler
    0, // USER_INT3_Handler
    0, // TIMER0_Handler            // 0x60
    (uint32_t)&TIMER1_Handler,      // 0x64
};
