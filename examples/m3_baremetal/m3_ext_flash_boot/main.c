/* main.c - m3_blink_led_btn2 */
#include "m3_regs.h"

void delay(volatile uint32_t count) {
    while (count--) {
        __asm("nop");
    }
}

int main(void) {
    // Configure UART0: 115200 baud @ 27MHz
    REG_UART0_BAUDDIV = 234;
    REG_UART0_CTRL = (1 << 0); // TX Enable

    // Configure GPIO0 (LED) as output
    REG_GPIO_OUTENSET = (1 << 0);

    // Configure GPIO1 and GPIO2 (Buttons) as inputs
    REG_GPIO_OUTENCLR = (1 << 1) | (1 << 2);

    uint32_t delay_val = 500000;

    while (1) {
        // Read buttons (Active-Low on Tang Nano 4K)
        uint32_t buttons = REG_GPIO_DATA & 0x2; // Bit 1

        if (!(buttons & (1 << 1))) {
            delay_val = 250000;
        } else {
            delay_val = 500000;
        }

        // Toggle LED
        REG_GPIO_DATAOUT ^= (1 << 0);

        // Print status to UART
        const char *msg = (REG_GPIO_DATAOUT & 1) ? "LED ON\r\n" : "LED OFF\r\n";
        while (msg && *msg) {
            while (REG_UART0_STATE & (1 << 0)); // Wait for TX buffer not full
            REG_UART0_DATA = *msg++;
        }

        delay(delay_val);
    }

    return 0;
}
