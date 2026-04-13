#include <stdint.h>

__attribute__((section(".page_1_code")))
uint32_t paged_function_1(uint32_t a, uint32_t b) {
    return a + b + 0x1111;
}

__attribute__((section(".page_2_code")))
uint32_t paged_function_2(uint32_t a, uint32_t b) {
    return a + b + 0x2222;
}
