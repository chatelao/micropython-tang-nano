/* uart.c */
#include <stdint.h>

#define UART0_BASE 0x40000000

typedef struct {
    volatile uint32_t DATA;
    volatile uint32_t STATE;
    volatile uint32_t CTRL;
    volatile uint32_t INTSTATUS;
    volatile uint32_t BAUDDIV;
} UART_TypeDef;

#define UART0 ((UART_TypeDef *)UART0_BASE)

void uart_init(uint32_t baudrate) {
    // Tentative initialization
    // UART0->BAUDDIV = ...
    // UART0->CTRL = ...
}

void uart_tx_char(char c) {
    while (UART0->STATE & 0x1); // Wait if full
    UART0->DATA = c;
}

char uart_rx_char(void) {
    while (!(UART0->STATE & 0x2)); // Wait if empty
    return UART0->DATA;
}
