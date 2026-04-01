/* main.c - m3_ext_flash_boot */
#include "m3_regs.h"

void delay(volatile uint32_t count) {
    while (count--) {
        __asm("nop");
    }
}

int main(void) {
    // Configure GPIO0 (LED) as output
    REG_GPIO_OUTENSET = (1 << 0);

    while (1) {
        // Toggle LED
        REG_GPIO_DATAOUT ^= (1 << 0);
        delay(250000); // 1/4 second blink
    }

    return 0;
}
