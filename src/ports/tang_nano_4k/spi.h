/* spi.h */
#ifndef SPI_H
#define SPI_H

#include "py/obj.h"

#define SPI_BASE 0x40002200

typedef struct {
    volatile uint32_t RDATA;  // 0x00: Reads data register
    volatile uint32_t WDATA;  // 0x04: Writes data register
    volatile uint32_t STATUS; // 0x08: Status register
    volatile uint32_t SSMASK; // 0x0C: Slave select mask register
    volatile uint32_t CTRL;   // 0x10: Control register
} SPI_TypeDef;

#define SPI0 ((SPI_TypeDef *)SPI_BASE)

// STATUS bits
#define SPI_STATUS_ERR  (1 << 7)
#define SPI_STATUS_RR   (1 << 6) // Receives ready status
#define SPI_STATUS_TR   (1 << 5) // Transmits ready status
#define SPI_STATUS_BSY  (1 << 4) // Be transmitting
#define SPI_STATUS_TOE  (1 << 3) // Transmits overrun error status
#define SPI_STATUS_ROE  (1 << 2) // Receives overrun error status

// CTRL bits
#define SPI_CTRL_CLKSEL_SHIFT (3)
#define SPI_CTRL_CLKSEL_MASK  (0x3 << SPI_CTRL_CLKSEL_SHIFT)
#define SPI_CTRL_POL          (1 << 2)
#define SPI_CTRL_PHA          (1 << 1)
#define SPI_CTRL_DIR          (1 << 0) // 0: MSB first, 1: LSB first

#define SPI_CLKSEL_DIV2 (0 << SPI_CTRL_CLKSEL_SHIFT)
#define SPI_CLKSEL_DIV4 (1 << SPI_CTRL_CLKSEL_SHIFT)
#define SPI_CLKSEL_DIV6 (2 << SPI_CTRL_CLKSEL_SHIFT)
#define SPI_CLKSEL_DIV8 (3 << SPI_CTRL_CLKSEL_SHIFT)

extern const mp_obj_type_t machine_spi_type;

#endif
