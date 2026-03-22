/* rtc.h */
#ifndef RTC_H
#define RTC_H

#include "py/obj.h"

#define RTC_BASE 0x40006000

typedef struct {
    volatile uint32_t CURRENT_DATA;  // 0x00: Data Register
    volatile uint32_t MATCH_VALUE;   // 0x04: Match Register
    volatile uint32_t LOAD_VALUE;    // 0x08: Load Register
    volatile uint32_t CTRL;          // 0x0C: Control Register
    volatile uint32_t IMSC;          // 0x10: Interrupt mask set and clear
    volatile uint32_t RIS;           // 0x14: Raw interrupt status
    volatile uint32_t MIS;           // 0x18: Masked interrupt status
    volatile uint32_t INTCLR;        // 0x1C: Interrupt clear register
} RTC_TypeDef;

#define RTC0 ((RTC_TypeDef *)RTC_BASE)

extern const mp_obj_type_t machine_rtc_type;

#endif
