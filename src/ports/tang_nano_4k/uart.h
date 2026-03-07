/* uart.h */
#ifndef UART_H
#define UART_H

#include <stdint.h>

void uart_init(uint32_t baudrate);
void uart_tx_char(char c);
char uart_rx_char(void);
int uart_rx_char_nonblocking(void);

#endif
