/* dma.h */
#ifndef DMA_H
#define DMA_H

#include <stdint.h>
#include "py/obj.h"

#define DMA_BASE (0x40002C00) // APB2 Slot 9 (0x400 aligned)

typedef struct {
    volatile uint32_t SRC;   // 0x00: Source address
    volatile uint32_t DST;   // 0x04: Destination address
    volatile uint32_t LEN;   // 0x08: Transfer length
    volatile uint32_t CTRL;  // 0x0C: Control and status
} DMA_TypeDef;

#define DMA0 ((DMA_TypeDef *)DMA_BASE)

// CTRL bits
#define DMA_CTRL_START (1 << 0)
#define DMA_CTRL_BUSY  (1 << 1)
#define DMA_CTRL_DONE  (1 << 2)

extern const mp_obj_type_t machine_fpga_dma_type;

#endif
