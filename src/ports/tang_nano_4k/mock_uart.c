/* mock_uart.c - for QEMU mps2-an385 machine (CMSDK UART) */
#include <stdint.h>
#include "uart.h"

#define UART0_BASE 0x40004000

typedef struct {
    volatile uint32_t DATA;
    volatile uint32_t STATE;
    volatile uint32_t CTRL;
    volatile uint32_t INTSTATUS;
    volatile uint32_t BAUDDIV;
} UART_TypeDef;

#define UART0 ((UART_TypeDef *)UART0_BASE)

void uart_init(uint32_t baudrate) {
    // Basic CMSDK UART initialization
    UART0->BAUDDIV = 16; // Dummy baud rate divider
    UART0->CTRL = 0x01;  // TX enable
    UART0->CTRL |= 0x02; // RX enable
}

void uart_tx_char(char c) {
    while (UART0->STATE & 0x1); // Wait for TX ready (bit 0 is TX full in CMSDK)
    UART0->DATA = c;
}

char uart_rx_char(void) {
    while (!(UART0->STATE & 0x2)); // Wait for RX ready (bit 1 is RX buffer full)
    return (char)UART0->DATA;
}
