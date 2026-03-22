/* spi.h */
#ifndef SPI_H
#define SPI_H

#include "py/obj.h"

#define SPI_BASE 0x40002400

typedef struct {
    volatile uint32_t RDATA;   // 0x00: Reads data register
    volatile uint32_t WDATA;   // 0x04: Writes data register
    volatile uint32_t STATUS;  // 0x08: Status register
    volatile uint32_t SSMASK;  // 0x0C: Slave select mask
    volatile uint32_t CTRL;    // 0x10: Control register
} SPI_TypeDef;

#define SPI0 ((SPI_TypeDef *)SPI_BASE)

// STATUS bits
#define SPI_STATUS_ERR  (1 << 7)
#define SPI_STATUS_RR   (1 << 6) // Receive Ready
#define SPI_STATUS_TR   (1 << 5) // Transmit Ready
#define SPI_STATUS_BT   (1 << 4) // Be Transmitting
#define SPI_STATUS_TOE  (1 << 3) // Transmit Overrun Error
#define SPI_STATUS_ROE  (1 << 2) // Receive Overrun Error

// CTRL bits
#define SPI_CTRL_CLK_DIV_2 (0 << 3)
#define SPI_CTRL_CLK_DIV_4 (1 << 3)
#define SPI_CTRL_CLK_DIV_6 (2 << 3)
#define SPI_CTRL_CLK_DIV_8 (3 << 3)
#define SPI_CTRL_POL       (1 << 2)
#define SPI_CTRL_PHA       (1 << 1)
#define SPI_CTRL_LSB       (1 << 0)

extern const mp_obj_type_t machine_spi_type;

#endif
