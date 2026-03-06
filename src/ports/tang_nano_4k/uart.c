/* uart.c */
#include "uart.h"

#define UART0_BASE 0x40000000

typedef struct {
    volatile uint32_t DATA;
    volatile uint32_t STATE;
    volatile uint32_t CTRL;
    volatile uint32_t INTSTATUS;
    volatile uint32_t BAUDDIV;
} UART_TypeDef;

#define UART0 ((UART_TypeDef *)UART0_BASE)

// Assuming 27MHz system clock for Tang Nano 4K
#define CPU_FREQ 27000000

void uart_init(uint32_t baudrate) {
    UART0->BAUDDIV = CPU_FREQ / baudrate;
    UART0->CTRL = 0x01; // Enable TX
    UART0->CTRL |= 0x02; // Enable RX
}

void uart_tx_char(char c) {
    while (UART0->STATE & 0x1); // Wait if TX buffer full
    UART0->DATA = c;
}

char uart_rx_char(void) {
    while (!(UART0->STATE & 0x2)); // Wait if RX buffer empty
    return UART0->DATA;
}
