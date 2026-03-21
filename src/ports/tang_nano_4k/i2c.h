/* i2c.h */
#ifndef I2C_H
#define I2C_H

#include "py/obj.h"

#define I2C_BASE 0x40002000

typedef struct {
    volatile uint32_t PRER;  // 0x00: Clock prescale register
    volatile uint32_t CTR;   // 0x04: Control register
    volatile uint32_t TXR;   // 0x08: Transmit data register
    volatile uint32_t RXR;   // 0x0C: Receive data register
    volatile uint32_t CR;    // 0x10: Command register
    volatile uint32_t SR;    // 0x14: Status register
} I2C_TypeDef;

#define I2C0 ((I2C_TypeDef *)I2C_BASE)

// CTR bits
#define I2C_CTR_EN  (1 << 7)
#define I2C_CTR_IEN (1 << 6)

// CR bits
#define I2C_CR_STA  (1 << 7)
#define I2C_CR_STO  (1 << 6)
#define I2C_CR_RD   (1 << 5)
#define I2C_CR_WR   (1 << 4)
#define I2C_CR_ACK  (1 << 3)
#define I2C_CR_IACK (1 << 0)

// SR bits
#define I2C_SR_RXACK (1 << 7)
#define I2C_SR_BUSY  (1 << 6)
#define I2C_SR_AL    (1 << 5)
#define I2C_SR_TIP   (1 << 1)
#define I2C_SR_IF    (1 << 0)

extern const mp_obj_type_t machine_i2c_type;

#endif
