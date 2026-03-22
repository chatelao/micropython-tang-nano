/* wdt.h */
#ifndef WDT_H
#define WDT_H

#include "py/obj.h"

#define WDT_BASE 0x40008000

typedef struct {
    volatile uint32_t LOAD;    // 0x00: Load register
    volatile uint32_t VALUE;   // 0x04: Value register
    volatile uint32_t CTRL;    // 0x08: Control register
    volatile uint32_t INTCLR;  // 0x0C: Interrupt clear register
    uint32_t RESERVED[764];    // Padding to 0xC00
    volatile uint32_t LOCK;    // 0xC00: Lock register
} WDT_TypeDef;

#define WDT0 ((WDT_TypeDef *)WDT_BASE)

#define WDT_UNLOCK_VALUE 0x1ACCE551

extern const mp_obj_type_t machine_wdt_type;

#endif
