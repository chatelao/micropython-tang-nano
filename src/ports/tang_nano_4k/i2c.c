/* i2c.c */
#include "i2c.h"
#include "py/runtime.h"
#include "py/mphal.h"
#include "extmod/modmachine.h"

typedef struct _machine_i2c_obj_t {
    mp_obj_base_t base;
    uint32_t freq;
} machine_i2c_obj_t;

static machine_i2c_obj_t machine_i2c_obj = {
    .base = { &machine_i2c_type },
    .freq = 100000,
};

static void i2c_wait(void) {
    while (I2C0->SR & I2C_SR_TIP);
}

static int i2c_transfer(mp_obj_base_t *self_in, uint16_t addr, size_t n, mp_machine_i2c_buf_t *bufs, unsigned int flags) {
    (void)self_in;

    // Start
    I2C0->TXR = (addr << 1) | (flags & MP_MACHINE_I2C_FLAG_READ ? 1 : 0);
    I2C0->CR = I2C_CR_STA | I2C_CR_WR;
    i2c_wait();

    if (I2C0->SR & I2C_SR_RXACK) {
        I2C0->CR = I2C_CR_STO;
        return -MP_ENODEV;
    }

    int num_acks = 0;
    for (; n--; ++bufs) {
        size_t len = bufs->len;
        uint8_t *buf = bufs->buf;
        if (flags & MP_MACHINE_I2C_FLAG_READ) {
            while (len--) {
                I2C0->CR = I2C_CR_RD | ((n == 0 && len == 0) ? I2C_CR_ACK : 0);
                i2c_wait();
                *buf++ = I2C0->RXR;
            }
        } else {
            while (len--) {
                I2C0->TXR = *buf++;
                I2C0->CR = I2C_CR_WR;
                i2c_wait();
                if (I2C0->SR & I2C_SR_RXACK) {
                    I2C0->CR = I2C_CR_STO;
                    return num_acks;
                }
                num_acks++;
            }
        }
    }

    if (flags & MP_MACHINE_I2C_FLAG_STOP) {
        I2C0->CR = I2C_CR_STO;
        i2c_wait();
    }

    return num_acks;
}

static void machine_i2c_init_func(mp_obj_base_t *self_in, size_t n_args, const mp_obj_t *pos_args, mp_map_t *kw_args) {
    enum { ARG_freq };
    static const mp_arg_t allowed_args[] = {
        { MP_QSTR_freq, MP_ARG_INT, {.u_int = 100000} },
    };

    machine_i2c_obj_t *self = (machine_i2c_obj_t *)self_in;
    mp_arg_val_t args[MP_ARRAY_SIZE(allowed_args)];
    mp_arg_parse_all(n_args, pos_args, kw_args, MP_ARRAY_SIZE(allowed_args), allowed_args, args);

    self->freq = args[ARG_freq].u_int;

    // sys_clk is 27MHz
    uint32_t prescale = 27000000 / (5 * self->freq) - 1;
    I2C0->PRER = prescale;
    I2C0->CTR = I2C_CTR_EN;
}

static mp_obj_t machine_i2c_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    mp_arg_check_num(n_args, n_kw, 0, MP_OBJ_FUN_ARGS_MAX, true);
    // Hardware I2C 0 is a singleton
    machine_i2c_obj_t *self = &machine_i2c_obj;
    mp_map_t kw_args;
    mp_map_init_fixed_table(&kw_args, n_kw, args + n_args);
    machine_i2c_init_func(&self->base, n_args, args, &kw_args);
    return MP_OBJ_FROM_PTR(self);
}

static const mp_machine_i2c_p_t machine_i2c_p = {
    .transfer = i2c_transfer,
    .init = machine_i2c_init_func,
};

MP_DEFINE_CONST_OBJ_TYPE(
    machine_i2c_type,
    MP_QSTR_I2C,
    MP_TYPE_FLAG_NONE,
    make_new, machine_i2c_make_new,
    protocol, &machine_i2c_p,
    locals_dict, &mp_machine_i2c_locals_dict
    );
