/* main.c - m3_blink_led_btn2 */
#include "m3_regs.h"

void delay(volatile uint32_t count) {
    while (count--) {
        __asm("nop");
    }
}

void uart_putc(char c) {
    while (REG_UART0_STATE & (1 << 0)); // Wait if TX buffer full
    REG_UART0_DATA = c;
}

void uart_puts(const char *s) {
    while (*s) uart_putc(*s++);
}

int main(void) {
    // Configure UART0
    REG_UART0_BAUDDIV = 27000000 / 115200;
    REG_UART0_CTRL = 0x01; // Enable TX

    uart_puts("M3 External Flash Boot Example\r\n");

    // Configure GPIO0 (LED) as output
    REG_GPIO_OUTENSET = (1 << 0);

    // Configure GPIO1 and GPIO2 (Buttons) as inputs (already default)
    REG_GPIO_OUTENCLR = (1 << 1) | (1 << 2);

    uint32_t delay_val = 500000;

    while (1) {
        // Read buttons (Active-Low on Tang Nano 4K)
        // GPIO1: Button S1, GPIO2: Button S2 (Used as hardware Reset)
        uint32_t buttons = REG_GPIO_DATA & 0x2; // Bit 1

        if (!(buttons & (1 << 1))) {
            delay_val = 250000;  // Double blink rate if Button 1 pressed (GND)
        } else {
            delay_val = 500000;  // Normal blink
        }

        // Toggle LED
        REG_GPIO_DATAOUT ^= (1 << 0);
        delay(delay_val);
    }

    return 0;
}