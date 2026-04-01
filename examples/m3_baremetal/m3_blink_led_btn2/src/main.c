/* main.c - m3_blink_led_btn2 */
#include "m3_regs.h"

void delay(volatile uint32_t count) {
    while (count--) {
        __asm("nop");
    }
}

void main(void) {
    // Configure GPIO0 (LED) as output
    REG_GPIO_OUTENSET = (1 << 0);

    // Configure GPIO1 (Button S1) as input (already default)
    REG_GPIO_OUTENCLR = (1 << 1);

    uint32_t delay_val = 500000;

    while (1) {
        // Read buttons (Active-Low on Tang Nano 4K)
        // Button S1 is on GPIO1
        // Button S2 is connected to reset_n and cannot be read via GPIO
        uint32_t buttons = REG_GPIO_DATA;

        if (!(buttons & (1 << 1))) {
            delay_val = 250000; // Double speed if Button S1 pressed (GND)
        } else {
            delay_val = 500000;  // Normal blink
        }

        // Toggle LED
        REG_GPIO_DATAOUT ^= (1 << 0);
        delay(delay_val);
    }
}
