/* main.c - m3_ext_flash_boot */
#include "m3_regs.h"

// --- Helper Functions for Trampoline ---
static inline uint32_t __get_PRIMASK(void) {
    uint32_t result;
    __asm volatile ("mrs %0, primask" : "=r" (result) :: "memory");
    return result;
}

static inline void __set_PRIMASK(uint32_t pri) {
    __asm volatile ("msr primask, %0" : : "r" (pri) : "memory");
}

static inline void __disable_irq(void) {
    __asm volatile ("cpsid i" : : : "memory");
}

// Declare the paged functions
uint32_t paged_function_1(uint32_t a, uint32_t b);
uint32_t paged_function_2(uint32_t a, uint32_t b);

// --- Application Logic ---
void delay(volatile uint32_t count) {
    while (count--) {
        __asm("nop");
    }
}

void uart_print(const char *msg) {
    while (msg && *msg) {
        while (REG_UART0_STATE & (1 << 0)); // Wait for TX buffer not full
        REG_UART0_DATA = *msg++;
    }
}

void print_hex(uint32_t val) {
    const char *hex = "0123456789ABCDEF";
    for (int i = 7; i >= 0; i--) {
        while (REG_UART0_STATE & (1 << 0));
        REG_UART0_DATA = hex[(val >> (i * 4)) & 0xF];
    }
}

int main(void) {
    // Configure UART0: 115200 baud @ 27MHz
    REG_UART0_BAUDDIV = 234;
    REG_UART0_CTRL = (1 << 0); // TX Enable

    // Configure GPIO0 (LED) as output
    REG_GPIO_OUTENSET = (1 << 0);

    uart_print("M3 External Flash Paging Demo\r\n");

    while (1) {
        // Toggle LED
        REG_GPIO_DATAOUT ^= (1 << 0);
        const char *led_msg = (REG_GPIO_DATAOUT & 1) ? "LED ON\r\n" : "LED OFF\r\n";
        uart_print(led_msg);

        // Call paged functions (now automatically mapped)
        uint32_t res1 = paged_function_1(0x10, 0x20);
        uint32_t res2 = paged_function_2(0x30, 0x40);

        uart_print("Res 1: 0x");
        print_hex(res1);
        uart_print("\r\n");

        uart_print("Res 2: 0x");
        print_hex(res2);
        uart_print("\r\n");

        delay(1000000);
    }

    return 0;
}
