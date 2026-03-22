#include <stdint.h>
#include "py/runtime.h"
#include "py/mperrno.h"
#include "adc.h"
#include "pin.h"

#define ADC_BASE (0x40002800)
#define REG_ADC_CFG  (*(volatile uint32_t *)(ADC_BASE + 0x00))
#define REG_ADC_DATA (*(volatile uint32_t *)(ADC_BASE + 0x04))
#define REG_ADC_STS  (*(volatile uint32_t *)(ADC_BASE + 0x08))

typedef struct _machine_adc_obj_t {
    mp_obj_base_t base;
    uint32_t channel;
} machine_adc_obj_t;

static void machine_adc_print(const mp_print_t *print, mp_obj_t self_in, mp_print_kind_t kind) {
    machine_adc_obj_t *self = MP_OBJ_TO_PTR(self_in);
    mp_printf(print, "ADC(channel=%u)", (unsigned int)self->channel);
}

static mp_obj_t machine_adc_make_new(const mp_obj_type_t *type, size_t n_args, size_t n_kw, const mp_obj_t *args) {
    mp_arg_check_num(n_args, n_kw, 1, 1, false);

    uint32_t channel;
    if (mp_obj_is_type(args[0], &machine_pin_type)) {
        // Mapping pin to ADC channel - for now just use the pin ID if it's < 8
        machine_pin_obj_t *pin = MP_OBJ_TO_PTR(args[0]);
        channel = pin->pin_id;
    } else {
        channel = mp_obj_get_int(args[0]);
    }

    if (channel >= 8) {
        mp_raise_ValueError(MP_ERROR_TEXT("invalid ADC channel"));
    }

    machine_adc_obj_t *self = mp_obj_malloc(machine_adc_obj_t, &machine_adc_type);
    self->base.type = &machine_adc_type;
    self->channel = channel;

    return MP_OBJ_FROM_PTR(self);
}

static mp_obj_t machine_adc_read_u16(mp_obj_t self_in) {
    machine_adc_obj_t *self = MP_OBJ_TO_PTR(self_in);

    // Start conversion on the selected channel
    REG_ADC_CFG = (1 << 7) | (self->channel & 0x07);

    // In simulation, we might not need to wait, but let's be realistic
    // Wait for conversion to complete (bit 0 of STS)
    // For now, in Renode simulation, we can assume it's instantaneous if not implemented specifically.
    // However, if we implement it as memory, it won't clear itself unless Renode script does it.
    // For simplicity in this simulated port, we just read the DATA register.

    uint32_t value = REG_ADC_DATA & 0xFFF;

    // Scale 12-bit to 16-bit
    return MP_OBJ_NEW_SMALL_INT((value << 4) | (value >> 8));
}
static MP_DEFINE_CONST_FUN_OBJ_1(machine_adc_read_u16_obj, machine_adc_read_u16);

static const mp_rom_map_elem_t machine_adc_locals_dict_table[] = {
    { MP_ROM_QSTR(MP_QSTR_read_u16), MP_ROM_PTR(&machine_adc_read_u16_obj) },
};
static MP_DEFINE_CONST_DICT(machine_adc_locals_dict, machine_adc_locals_dict_table);

MP_DEFINE_CONST_OBJ_TYPE(
    machine_adc_type,
    MP_QSTR_ADC,
    MP_TYPE_FLAG_NONE,
    make_new, machine_adc_make_new,
    print, machine_adc_print,
    locals_dict, &machine_adc_locals_dict
);
