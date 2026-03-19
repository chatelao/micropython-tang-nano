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

// Heap for MicroPython - 12KB to avoid MemoryError during compilation and execution
static char heap[12 * 1024];
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

void Default_Handler(void) {
    while (1);
}

extern void SysTick_Handler(void);

void TIMER1_Handler(void) {
    // Clear Timer 1 interrupt
    (*(volatile uint32_t *)0x4000100C) = 1;
    machine_pwm_tick();
}

void gc_collect(void) {
    void *dummy;
    gc_collect_start();
    // Scan stack
    gc_collect_root(&dummy, ((mp_uint_t)stack_top - (mp_uint_t)&dummy) / sizeof(mp_uint_t));
    // Scan MicroPython state
    gc_collect_root((void **)&mp_state_ctx, sizeof(mp_state_ctx) / sizeof(size_t));
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
    (uint32_t)&Default_Handler, // NMI
    (uint32_t)&Default_Handler, // HardFault
    (uint32_t)&Default_Handler, // MemManage
    (uint32_t)&Default_Handler, // BusFault
    (uint32_t)&Default_Handler, // UsageFault
    0, 0, 0, 0,                 // Reserved
    (uint32_t)&Default_Handler, // SVCall
    (uint32_t)&Default_Handler, // DebugMonitor
    0,                          // Reserved
    (uint32_t)&Default_Handler, // PendSV
    (uint32_t)&SysTick_Handler, // SysTick
    0, 0, 0, 0, 0, 0, 0, 0, 0,  // IRQ 0-8
    (uint32_t)&TIMER1_Handler,  // IRQ 9
};
