/* spi.c */
#include "spi.h"
#include "pin.h"
#include "py/runtime.h"
#include "py/mphal.h"
#include "py/mperrno.h"
#include "extmod/modmachine.h"

typedef struct _machine_spi_obj_t {
    mp_obj_base_t base;
    uint32_t baudrate;
    uint8_t polarity;
    uint8_t phase;
    uint8_t bits;
    uint8_t firstbit;
} machine_spi_obj_t;

static machine_spi_obj_t machine_spi_obj = {
    .base = { &machine_spi_type },
    .baudrate = 1000000,
    .polarity = 0,
    .phase = 0,
    .bits = 8,
    .firstbit = 0, // MSB
};

static void machine_spi_transfer(mp_obj_base_t *self_in, size_t len, const uint8_t *src, uint8_t *dest) {
    (void)self_in;
    for (size_t i = 0; i < len; i++) {
        uint8_t data_out = src ? src[i] : 0xFF;

        // Wait for TX ready
        #ifndef SIMULATION
        while (!(SPI0->STATUS & SPI_STATUS_TR));
        #endif

        SPI0->WDATA = data_out;

        // Wait for RX ready
        #ifndef SIMULATION
        while (!(SPI0->STATUS & SPI_STATUS_RR));
        #endif

        uint8_t data_in = SPI0->RDATA;
        if (dest) {
            dest[i] = data_in;
        }
    }
}

static void machine_spi_init_func(mp_obj_base_t *self_in, size_t n_args, const mp_obj_t *pos_args, mp_map_t *kw_args) {
    enum { ARG_id, ARG_baudrate, ARG_polarity, ARG_phase, ARG_bits, ARG_firstbit, ARG_sck, ARG_mosi, ARG_miso };
    static const mp_arg_t allowed_args[] = {
        { MP_QSTR_id, MP_ARG_INT, {.u_int = 0} },
        { MP_QSTR_baudrate, MP_ARG_INT, {.u_int = 1000000} },
        { MP_QSTR_polarity, MP_ARG_KW_ONLY | MP_ARG_INT, {.u_int = 0} },
        { MP_QSTR_phase, MP_ARG_KW_ONLY | MP_ARG_INT, {.u_int = 0} },
        { MP_QSTR_bits, MP_ARG_KW_ONLY | MP_ARG_INT, {.u_int = 8} },
        { MP_QSTR_firstbit, MP_ARG_KW_ONLY | MP_ARG_INT, {.u_int = 0} }, // 0: MSB
        { MP_QSTR_sck, MP_ARG_KW_ONLY | MP_ARG_OBJ, {.u_rom_obj = MP_ROM_NONE} },
        { MP_QSTR_mosi, MP_ARG_KW_ONLY | MP_ARG_OBJ, {.u_rom_obj = MP_ROM_NONE} },
        { MP_QSTR_miso, MP_ARG_KW_ONLY | MP_ARG_OBJ, {.u_rom_obj = MP_ROM_NONE} },
    };

    machine_spi_obj_t *self = (machine_spi_obj_t *)self_in;
    mp_arg_val_t args[MP_ARRAY_SIZE(allowed_args)];
    mp_arg_parse_all(n_args, pos_args, kw_args, MP_ARRAY_SIZE(allowed_args), allowed_args, args);

    if (args[ARG_id].u_int != 0) {
        mp_raise_msg_varg(&mp_type_ValueError, MP_ERROR_TEXT("SPI(%d) doesn't exist"), args[ARG_id].u_int);
    }

    self->baudrate = args[ARG_baudrate].u_int;
    self->polarity = args[ARG_polarity].u_int;
    self->phase = args[ARG_phase].u_int;
    self->bits = args[ARG_bits].u_int;
    self->firstbit = args[ARG_firstbit].u_int;

    if (self->bits != 8) {
        mp_raise_ValueError(MP_ERROR_TEXT("bits must be 8"));
    }

    uint32_t ctrl = 0;

    // Gowin SPI clock divider: CLKDIV = (CLKSEL + 1) * 2
    // sys_clk = 27MHz
    // Dividers: 2, 4, 6, 8
    // Frequencies: 13.5MHz, 6.75MHz, 4.5MHz, 3.375MHz

    if (self->baudrate >= 13500000) {
        ctrl |= SPI_CTRL_CLK_DIV_2;
    } else if (self->baudrate >= 6750000) {
        ctrl |= SPI_CTRL_CLK_DIV_4;
    } else if (self->baudrate >= 4500000) {
        ctrl |= SPI_CTRL_CLK_DIV_6;
    } else {
        ctrl |= SPI_CTRL_CLK_DIV_8;
    }

    if (self->polarity) {
        ctrl |= SPI_CTRL_POL;
    }
    if (self->phase) {
        ctrl |= SPI_CTRL_PHA;
    }
    if (self->firstbit == 1) { // LSB
        ctrl |= SPI_CTRL_LSB;
    }

    SPI0->CTRL = ctrl;
    SPI0->SSMASK = 0xFF; // Unused for now
}

static mp_obj_t machine_spi_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    machine_spi_obj_t *self = &machine_spi_obj;
    mp_map_t kw_args;
    mp_map_init_fixed_table(&kw_args, n_kw, args + n_args);
    machine_spi_init_func(&self->base, n_args, args, &kw_args);
    return MP_OBJ_FROM_PTR(self);
}

static const mp_machine_spi_p_t machine_spi_p = {
    .transfer = machine_spi_transfer,
    .init = machine_spi_init_func,
};

MP_DEFINE_CONST_OBJ_TYPE(
    machine_spi_type,
    MP_QSTR_SPI,
    MP_TYPE_FLAG_NONE,
    make_new, machine_spi_make_new,
    protocol, &machine_spi_p,
    locals_dict, &mp_machine_spi_locals_dict
    );
