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
#include "pin.h"
#include "timer.h"
#include "pwm.h"
#include "flash.h"
#include "extmod/vfs.h"
#include "extmod/vfs_lfs.h"

extern char _sheap, _eheap;
static char *stack_top;

int main(int argc, char **argv) {
    int stack_dummy;
    stack_top = (char *)&stack_dummy;
    mp_stack_set_limit(2048);

    for (;;) {
        gc_init(&_sheap, &_eheap);
        mp_init();
        mp_hal_init();

        // Initialize the flash and mount the VFS
        flash_init();
        mp_obj_t bdev = MP_OBJ_FROM_PTR(&machine_flash_obj);
        mp_vfs_mount_and_chdir_protected(bdev, MP_OBJ_NEW_QSTR(MP_QSTR_littlefs));

        printf("\nMicroPython started on Tang Nano 4K\n");
        printf("Tang Nano 4K with GW1NSR-LV4C\n");

        for (;;) {
            if (pyexec_mode_kind == PYEXEC_MODE_RAW_REPL) {
                if (pyexec_raw_repl() != 0) {
                    break;
                }
            } else {
                if (pyexec_friendly_repl() == 0) {
                    break;
                }
            }
        }

        printf("soft reboot\n");
        mp_deinit();
    }

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

void GPIO_Handler(uint32_t pin_id) {
    // Clear GPIO interrupt
    REG_INTSTATUS = (1 << pin_id);
    machine_pin_dispatch_irq(pin_id);
}

void PORT0_0_Handler(void) { GPIO_Handler(0); }
void PORT0_1_Handler(void) { GPIO_Handler(1); }
void PORT0_2_Handler(void) { GPIO_Handler(2); }
void PORT0_3_Handler(void) { GPIO_Handler(3); }
void PORT0_4_Handler(void) { GPIO_Handler(4); }
void PORT0_5_Handler(void) { GPIO_Handler(5); }
void PORT0_6_Handler(void) { GPIO_Handler(6); }
void PORT0_7_Handler(void) { GPIO_Handler(7); }
void PORT0_8_Handler(void) { GPIO_Handler(8); }
void PORT0_9_Handler(void) { GPIO_Handler(9); }
void PORT0_10_Handler(void) { GPIO_Handler(10); }
void PORT0_11_Handler(void) { GPIO_Handler(11); }
void PORT0_12_Handler(void) { GPIO_Handler(12); }
void PORT0_13_Handler(void) { GPIO_Handler(13); }
void PORT0_14_Handler(void) { GPIO_Handler(14); }
void PORT0_15_Handler(void) { GPIO_Handler(15); }

void gc_collect(void) {
    void *dummy;
    gc_collect_start();
    // Scan stack
    gc_collect_root(&dummy, ((mp_uint_t)stack_top - (mp_uint_t)&dummy) / sizeof(mp_uint_t));
    // Scan MicroPython state
    gc_collect_root((void **)&mp_state_ctx, sizeof(mp_state_ctx) / sizeof(size_t));
    gc_collect_end();
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
    0, 0, 0, 0, 0, 0, 0, 0,     // IRQ 0-7
    0,                          // IRQ 8 (TIMER 0)
    (uint32_t)&TIMER1_Handler,  // IRQ 9
    0, 0, 0, 0, 0, 0,           // IRQ 10-15
    (uint32_t)&PORT0_0_Handler, // IRQ 16
    (uint32_t)&PORT0_1_Handler, // IRQ 17
    (uint32_t)&PORT0_2_Handler, // IRQ 18
    (uint32_t)&PORT0_3_Handler, // IRQ 19
    (uint32_t)&PORT0_4_Handler, // IRQ 20
    (uint32_t)&PORT0_5_Handler, // IRQ 21
    (uint32_t)&PORT0_6_Handler, // IRQ 22
    (uint32_t)&PORT0_7_Handler, // IRQ 23
    (uint32_t)&PORT0_8_Handler, // IRQ 24
    (uint32_t)&PORT0_9_Handler, // IRQ 25
    (uint32_t)&PORT0_10_Handler, // IRQ 26
    (uint32_t)&PORT0_11_Handler, // IRQ 27
    (uint32_t)&PORT0_12_Handler, // IRQ 28
    (uint32_t)&PORT0_13_Handler, // IRQ 29
    (uint32_t)&PORT0_14_Handler, // IRQ 30
    (uint32_t)&PORT0_15_Handler, // IRQ 31
};
