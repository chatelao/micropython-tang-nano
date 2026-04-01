/* main.c - m3_ext_psgram */
#include "../common/m3_regs.h"

void delay(volatile uint32_t count) {
    while (count--) {
        __asm("nop");
    }
}

void main(void) {
    // Configure GPIO0 (LED) as output
    REG_GPIO_OUTENSET = (1 << 0);

    // PSRAM write/read test
    volatile uint32_t *psram = (volatile uint32_t *)PSRAM_BASE;
    psram[0] = 0x12345678;
    psram[1] = 0x87654321;

    uint32_t blink_delay = 500000;

    // Verify PSRAM
    if (psram[0] == 0x12345678 && psram[1] == 0x87654321) {
        // Success: normal blink
        blink_delay = 500000;
    } else {
        // Failure: fast blink
        blink_delay = 100000;
    }

    while (1) {
        // Toggle LED
        REG_GPIO_DATAOUT ^= (1 << 0);
        delay(blink_delay);
    }
}
