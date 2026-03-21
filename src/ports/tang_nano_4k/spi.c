/* spi.c */
#include "spi.h"
#include <stdio.h>
#include "py/runtime.h"
#include "py/mphal.h"
#include "py/mperrno.h"
#include "extmod/modmachine.h"

typedef struct _machine_spi_obj_t {
    mp_obj_base_t base;
    uint32_t baudrate;
    uint8_t polarity;
    uint8_t phase;
    uint8_t firstbit;
} machine_spi_obj_t;

static machine_spi_obj_t machine_spi_obj = {
    .base = { &machine_spi_type },
    .baudrate = 1000000,
    .polarity = 0,
    .phase = 0,
    .firstbit = 0,
};

static void spi_wait_tr(void) {
    uint32_t timeout = 100000;
    while (!(SPI0->STATUS & SPI_STATUS_TR) && --timeout);
}

static void spi_wait_rr(void) {
    uint32_t timeout = 100000;
    while (!(SPI0->STATUS & SPI_STATUS_RR) && --timeout);
}

static void spi_wait_bsy(void) {
    uint32_t timeout = 100000;
    while ((SPI0->STATUS & SPI_STATUS_BSY) && --timeout);
}

static void machine_spi_transfer(mp_obj_base_t *self_in, size_t len, const uint8_t *src, uint8_t *dest) {
    (void)self_in;
    for (size_t i = 0; i < len; i++) {
        spi_wait_tr();
        SPI0->WDATA = src ? src[i] : 0xFF;
        spi_wait_rr();
        uint8_t data = SPI0->RDATA;
        if (dest) {
            dest[i] = data;
        }
    }
    spi_wait_bsy();
}

static void machine_spi_init_func(mp_obj_base_t *self_in, size_t n_args, const mp_obj_t *pos_args, mp_map_t *kw_args) {
    enum { ARG_id, ARG_baudrate, ARG_polarity, ARG_phase, ARG_bits, ARG_firstbit, ARG_sck, ARG_mosi, ARG_miso };
    static const mp_arg_t allowed_args[] = {
        { MP_QSTR_id, MP_ARG_INT, {.u_int = 0} },
        { MP_QSTR_baudrate, MP_ARG_INT, {.u_int = 1000000} },
        { MP_QSTR_polarity, MP_ARG_KW_ONLY | MP_ARG_INT, {.u_int = 0} },
        { MP_QSTR_phase, MP_ARG_KW_ONLY | MP_ARG_INT, {.u_int = 0} },
        { MP_QSTR_bits, MP_ARG_KW_ONLY | MP_ARG_INT, {.u_int = 8} },
        { MP_QSTR_firstbit, MP_ARG_KW_ONLY | MP_ARG_INT, {.u_int = 0} },
        { MP_QSTR_sck, MP_ARG_KW_ONLY | MP_ARG_OBJ, {.u_obj = MP_OBJ_NULL} },
        { MP_QSTR_mosi, MP_ARG_KW_ONLY | MP_ARG_OBJ, {.u_obj = MP_OBJ_NULL} },
        { MP_QSTR_miso, MP_ARG_KW_ONLY | MP_ARG_OBJ, {.u_obj = MP_OBJ_NULL} },
    };

    machine_spi_obj_t *self = (machine_spi_obj_t *)self_in;
    mp_arg_val_t args[MP_ARRAY_SIZE(allowed_args)];
    mp_arg_parse_all(n_args, pos_args, kw_args, MP_ARRAY_SIZE(allowed_args), allowed_args, args);

    if (args[ARG_bits].u_int != 8) {
        mp_raise_ValueError(MP_ERROR_TEXT("only 8 bits supported"));
    }

    self->baudrate = args[ARG_baudrate].u_int;
    if (self->baudrate == 0) {
        mp_raise_ValueError(MP_ERROR_TEXT("baudrate cannot be 0"));
    }
    self->polarity = args[ARG_polarity].u_int;
    self->phase = args[ARG_phase].u_int;
    self->firstbit = args[ARG_firstbit].u_int;

    // CLKDIV = (CLKSEL + 1) * 2
    // sys_clk = 27MHz
    // CLKDIV = 27MHz / baudrate
    // CLKSEL = (27MHz / baudrate) / 2 - 1

    uint32_t clkdiv = 27000000 / self->baudrate;
    uint32_t clksel;
    if (clkdiv <= 2) clksel = 0;      // Div 2
    else if (clkdiv <= 4) clksel = 1; // Div 4
    else if (clkdiv <= 6) clksel = 2; // Div 6
    else clksel = 3;                 // Div 8 (maximum)

    uint32_t ctrl = (clksel << SPI_CTRL_CLKSEL_SHIFT);
    if (self->polarity) ctrl |= SPI_CTRL_POL;
    if (self->phase) ctrl |= SPI_CTRL_PHA;
    if (self->firstbit == 1) ctrl |= SPI_CTRL_DIR; // 1: LSB first

    SPI0->CTRL = ctrl;
    SPI0->SSMASK = 0; // Not using hardware slave select for now
}

static mp_obj_t machine_spi_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    // Hardware SPI 0 is a singleton
    machine_spi_obj_t *self = &machine_spi_obj;
    mp_map_t kw_args;
    mp_map_init_fixed_table(&kw_args, n_kw, args + n_args);
    machine_spi_init_func(&self->base, n_args, args, &kw_args);
    return MP_OBJ_FROM_PTR(self);
}

static void machine_spi_print(const mp_print_t *print, mp_obj_t self_in, mp_print_kind_t kind) {
    machine_spi_obj_t *self = MP_OBJ_TO_PTR(self_in);
    mp_printf(print, "SPI(0, baudrate=%u, polarity=%u, phase=%u, bits=8, firstbit=%u)",
        self->baudrate, self->polarity, self->phase, self->firstbit);
}

static const mp_machine_spi_p_t machine_spi_p = {
    .init = machine_spi_init_func,
    .transfer = machine_spi_transfer,
};

MP_DEFINE_CONST_OBJ_TYPE(
    machine_spi_type,
    MP_QSTR_SPI,
    MP_TYPE_FLAG_NONE,
    make_new, machine_spi_make_new,
    print, machine_spi_print,
    protocol, &machine_spi_p,
    locals_dict, &mp_machine_spi_locals_dict
    );
