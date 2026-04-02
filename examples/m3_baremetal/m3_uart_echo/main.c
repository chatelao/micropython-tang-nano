/* main.c - m3_uart_echo */
#include "m3_regs.h"

int main(void) {
    // Configure UART0: 115200 baud @ 27MHz
    // Divider = 27,000,000 / 115,200 = 234.375 -> 234
    REG_UART0_BAUDDIV = 234;

    // Enable UART0 TX and RX
    // CTRL[0] = TX Enable, CTRL[1] = RX Enable
    REG_UART0_CTRL = (1 << 1) | (1 << 0);

    // Configure GPIO0 (LED) as output
    REG_GPIO_OUTENSET = (1 << 0);

    while (1) {
        // Poll for RX buffer full (STATE[1])
        if (REG_UART0_STATE & (1 << 1)) {
            // Read received character
            uint8_t c = (uint8_t)REG_UART0_DATA;

            // Toggle LED
            REG_GPIO_DATAOUT ^= (1 << 0);

            // Case conversion
            if (c >= 'a' && c <= 'z') {
                c = c - ('a' - 'A');
            } else if (c >= 'A' && c <= 'Z') {
                c = c + ('a' - 'A');
            }

            // Wait for TX buffer not full (STATE[0] == 0)
            while (REG_UART0_STATE & (1 << 0));

            // Echo character back
            REG_UART0_DATA = c;
        }
    }

    return 0;
}
