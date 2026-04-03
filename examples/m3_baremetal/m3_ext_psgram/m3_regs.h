#ifndef M3_REGS_H
#define M3_REGS_H

#include <stdint.h>

// --- GPIO (CMSDK) ---
#define GPIO_BASE           (0x40010000)
#define REG_GPIO_DATA       (*(volatile uint32_t *)(GPIO_BASE + 0x00))
#define REG_GPIO_DATAOUT    (*(volatile uint32_t *)(GPIO_BASE + 0x04))
#define REG_GPIO_OUTENSET   (*(volatile uint32_t *)(GPIO_BASE + 0x10))
#define REG_GPIO_OUTENCLR   (*(volatile uint32_t *)(GPIO_BASE + 0x14))
#define REG_GPIO_INTENSET   (*(volatile uint32_t *)(GPIO_BASE + 0x20))
#define REG_GPIO_INTENCLR   (*(volatile uint32_t *)(GPIO_BASE + 0x24))
#define REG_GPIO_INTTYPESET (*(volatile uint32_t *)(GPIO_BASE + 0x28))
#define REG_GPIO_INTTYPECLR (*(volatile uint32_t *)(GPIO_BASE + 0x2C))
#define REG_GPIO_INTPOLSET  (*(volatile uint32_t *)(GPIO_BASE + 0x30))
#define REG_GPIO_INTPOLCLR  (*(volatile uint32_t *)(GPIO_BASE + 0x34))
#define REG_GPIO_INTSTATUS  (*(volatile uint32_t *)(GPIO_BASE + 0x38))

// --- NVIC ---
#define NVIC_ISER0          (*(volatile uint32_t *)(0xE000E100))
#define NVIC_ICER0          (*(volatile uint32_t *)(0xE000E180))

// --- Memory Regions ---
#define SRAM_BASE           (0x20000000)
#define SRAM_SIZE           (22 * 1024)
#define PSRAM_BASE          (0x60000000)
#define PSRAM_SIZE          (8 * 1024 * 1024)

#endif // M3_REGS_H
