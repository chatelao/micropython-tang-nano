/* main.c - m3_ext_flash_boot */
#include "m3_regs.h"

// --- Helper Functions for Trampoline ---
// --- Helper Functions for Trampoline ---

/**
 * Gets the current PRIMASK register value (Interrupt state).
 */
static inline uint32_t __get_PRIMASK(void) {
    uint32_t result;
    __asm volatile ("mrs %0, primask" : "=r" (result) :: "memory");
    return result;
}

/**
 * Sets the PRIMASK register value.
 */
static inline void __set_PRIMASK(uint32_t pri) {
    __asm volatile ("msr primask, %0" : : "r" (pri) : "memory");
}

/**
 * Disables all interrupts by setting PRIMASK to 1.
 */
static inline void __disable_irq(void) {
    __asm volatile ("cpsid i" : : : "memory");
}

// --- Trampoline (Must run from SRAM) ---

/**
 * The trampoline allows the M3 to execute code from different 64KB Flash banks
 * by dynamically switching the hardware bank register.
 *
 * Crucially, this function is placed in SRAM (.ramfunc) because the M3's
 * instruction bus would lock up if it tried to fetch instructions from the
 * Flash while the bank switching is in progress (due to the AHB bridge
 * reconfiguring the address mapping).
 *
 * Process:
 * 1. Disable interrupts to prevent ISRs from executing during the transition.
 * 2. Save the current bank and switch to the target bank (from target_addr).
 * 3. Use memory/pipeline barriers (DSB/ISB) to ensure the hardware is ready.
 * 4. Call the real function using its 64KB-window-relative address.
 * 5. Restore the original bank and re-synchronize.
 * 6. Restore the interrupt state.
 */
__attribute__((section(".ramfunc"), noinline))
uint32_t trampoline(void *target_func, uint32_t arg1, uint32_t arg2) {
    uint32_t target_addr = (uint32_t)target_func;

    // Calculate bank index (64KB per bank) from the 8MB virtual address
    // Virtual addresses are 0x60000000 to 0x607FFFFF.
    // Physical flash address is (target_addr - 0x60000000).
    uint32_t flash_offset = target_addr - 0x60000000;
    uint32_t target_bank = flash_offset >> 16;

    // Create the jump address within the 64KB window (0x60000000 range)
    // The lower 16 bits are the offset within the bank.
    uint32_t window_addr = 0x60000000 | (flash_offset & 0xFFFF);
    uint32_t (*real_func)(uint32_t, uint32_t) = (uint32_t (*)(uint32_t, uint32_t))window_addr;

    // 1. Save and disable interrupts
    uint32_t pri = __get_PRIMASK();
    __disable_irq();

    // 2. Save current bank and switch to the target page
    uint32_t old_bank = *HW_BANK_REG;
    *HW_BANK_REG = target_bank;

    // 3. Synchronization barriers
    // DSB ensures the write to HW_BANK_REG is complete.
    // ISB flushes the pipeline so the next fetch uses the new mapping.
    __asm volatile("dsb" : : : "memory");
    __asm volatile("isb" : : : "memory");

    // 4. Execute the actual function in the paged flash window
    uint32_t result = real_func(arg1, arg2);

    // 5. Restore original bank state
    *HW_BANK_REG = old_bank;

    // 6. Re-synchronize
    __asm volatile("dsb" : : : "memory");
    __asm volatile("isb" : : : "memory");

    // 7. Restore interrupt state
    __set_PRIMASK(pri);

    return result;
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

        // Call paged functions via the trampoline.
        // Even though they are located in different 64KB banks (due to
        // the linker script placing paged_code.o at 0x60400000), the
        // trampoline handles the bank switching transparently.
        uint32_t res1 = trampoline(paged_function_1, 0x10, 0x20);
        uint32_t res2 = trampoline(paged_function_2, 0x30, 0x40);

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
