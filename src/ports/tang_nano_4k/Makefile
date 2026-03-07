include ../../lib/micropython/py/mkenv.mk

# qstr definitions (must come before including py.mk)
QSTR_DEFS = qstrdefsport.h

# MicroPython feature configurations
MICROPY_ROM_TEXT_COMPRESSION ?= 1
MICROPY_PY_BUILTINS_FLOAT ?= 1
MICROPY_PY_MATH ?= 1
MICROPY_ENABLE_COMPILER ?= 1
MICROPY_PY_SYS_STDFILES ?= 1

# include py core make definitions
include $(TOP)/py/py.mk

CROSS_COMPILE ?= arm-none-eabi-

INC += -I.
INC += -I$(TOP)
INC += -I$(BUILD)

CFLAGS_CORTEX_M3 = -mthumb -mcpu=cortex-m3
CFLAGS += $(INC) -Wall -Werror -std=c99 $(CFLAGS_CORTEX_M3) $(COPT)

# Simulation support
ifeq ($(SIMULATION), 1)
FLASH_ORIGIN = 0x60000000
FLASH_LENGTH = 4M
else
FLASH_ORIGIN = 0x00000000
FLASH_LENGTH = 32K
endif

LDFLAGS += -T tang_nano_4k.ld -Wl,-Map=$@.map,--cref,--gc-sections --specs=nosys.specs
LDFLAGS += -Wl,--defsym=FLASH_ORIGIN=$(FLASH_ORIGIN),--defsym=FLASH_LENGTH=$(FLASH_LENGTH)

# Tune for Debugging or Optimization
CFLAGS += -g  # always include debug info in the ELF
ifeq ($(DEBUG), 1)
CFLAGS += -O0
else
CFLAGS += -Os -DNDEBUG
CFLAGS += -fdata-sections -ffunction-sections
endif

SRC_C = \
	main.c \
	mphalport.c \
	uart.c \
	$(TOP)/shared/libc/printf.c \
	$(TOP)/shared/runtime/stdout_helpers.c \

# Include REPL and compiler only if enabled
ifeq ($(MICROPY_ENABLE_COMPILER), 1)
SRC_C += \
	$(TOP)/shared/readline/readline.c \
	$(TOP)/shared/runtime/pyexec.c
SRC_QSTR += $(TOP)/shared/readline/readline.c $(TOP)/shared/runtime/pyexec.c
endif

OBJ += $(PY_CORE_O)
OBJ += $(addprefix $(BUILD)/, $(filter-out $(TOP)/%, $(SRC_C:.c=.o)))
OBJ += $(addprefix $(BUILD)/, $(patsubst $(TOP)/%, %, $(filter $(TOP)/%, $(SRC_C:.c=.o))))

all: $(BUILD)/firmware.bin

$(BUILD)/firmware.elf: $(OBJ)
	$(ECHO) "LINK $@"
	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
	$(Q)$(SIZE) $@

$(BUILD)/firmware.bin: $(BUILD)/firmware.elf
	$(Q)$(OBJCOPY) -O binary $^ $@

include $(TOP)/py/mkrules.mk
