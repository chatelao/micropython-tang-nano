/* main.c */
#include "py/compile.h"
#include "py/runtime.h"
#include "py/gc.h"
#include "py/stackctrl.h"
#include "shared/runtime/pyexec.h"

void mp_hal_init(void);

int main(int argc, char **argv) {
    mp_stack_set_limit(2048);
    // gc_init(heap, heap + sizeof(heap));
    mp_init();
    mp_hal_init();

    for (;;) {
        if (pyexec_friendly_repl() != 0) {
            break;
        }
    }

    mp_deinit();
    return 0;
}

void nlr_jump_fail(void *val) {
    while (1);
}

void NORETURN __fatal_error(const char *msg) {
    while (1);
}
