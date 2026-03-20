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

LDFLAGS += -T tang_nano_4k.ld -Wl,-Map=$@.map,--cref,--gc-sections --specs=nosys.specs -lc -lm -lnosys
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
	pin.c \
	timer.c \
	pwm.c \
	adc.c \
	flash.c \
	modmachine.c \
	$(TOP)/extmod/vfs.c \
	$(TOP)/extmod/vfs_lfsx.c \
	$(TOP)/extmod/vfs_reader.c \
	$(TOP)/extmod/modos.c \
	$(TOP)/extmod/modtime.c \
	$(TOP)/lib/littlefs/lfs2.c \
	$(TOP)/lib/littlefs/lfs2_util.c \
	$(TOP)/extmod/machine_i2c.c \
	$(TOP)/extmod/machine_spi.c \
	$(TOP)/drivers/bus/softspi.c \
	$(TOP)/extmod/virtpin.c \
	$(TOP)/shared/libc/printf.c \
	$(TOP)/shared/runtime/stdout_helpers.c \

SRC_QSTR += $(SRC_C)

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

# Disable unused-function warning for LittleFS as it has several static functions
# only used in assertions, which are disabled in release builds.
$(BUILD)/lib/littlefs/lfs2.o: CFLAGS += -Wno-unused-function

include $(TOP)/py/mkrules.mk
