include ../../lib/micropython/py/mkenv.mk

# qstr definitions (must come before including py.mk)
QSTR_DEFS = qstrdefsport.h

# MicroPython feature configurations
MICROPY_ROM_TEXT_COMPRESSION ?= 1
MICROPY_PY_BUILTINS_FLOAT ?= 0
MICROPY_PY_MATH ?= 0
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
ifeq ($(SIMULATION), 1)
CFLAGS += -DSIMULATION=1
endif
# Disable some warnings for external libraries
CFLAGS_MOD = -Wno-unused-function

# Simulation support
ifeq ($(SIMULATION), 1)
FLASH_ORIGIN = 0x60000000
FLASH_LENGTH = 4M
else
FLASH_ORIGIN = 0x00000000
# The GW1NSR-4C has 128KB of address space for instruction flash (0x00000 to 0x1FFFF)
# as per the memory map in the GW1NSR-4C datasheet.
FLASH_LENGTH = 128K
endif

LDFLAGS += -T tang_nano_4k.ld -Wl,-Map=$@.map,--cref,--gc-sections --specs=nano.specs --specs=nosys.specs -lc -lnosys
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
	i2c.c \
	spi.c \
	rtc.c \
	wdt.c \
	bridge.c \
	modmachine.c \
	$(TOP)/shared/timeutils/timeutils.c \
	$(TOP)/extmod/modtime.c \
	$(TOP)/extmod/machine_mem.c \
	$(TOP)/extmod/machine_i2c.c \
	$(TOP)/extmod/machine_spi.c \
	$(TOP)/drivers/bus/softspi.c \
	$(TOP)/extmod/virtpin.c \
	$(TOP)/extmod/modvfs.c \
	$(TOP)/extmod/vfs.c \
	$(TOP)/extmod/vfs_lfs.c \
	$(TOP)/extmod/vfs_reader.c \
	$(TOP)/extmod/vfs_blockdev.c \
	$(TOP)/extmod/modos.c \
	$(TOP)/lib/littlefs/lfs2.c \
	$(TOP)/lib/littlefs/lfs2_util.c \
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

# Filter out irrelevant architecture-specific object files from PY_CORE_O
# to reduce binary size and ensure it fits in the 32KB FLASH.
# This removes NLR and EMIT support for non-target architectures.
EXCLUDE_OBJ = \
	py/nlrx86.o \
	py/nlrx64.o \
	py/nlraarch64.o \
	py/nlrmips.o \
	py/nlrpowerpc.o \
	py/nlrxtensa.o \
	py/nlrrv32.o \
	py/nlrrv64.o \
	py/nlrsetjmp.o \
	py/asmx64.o \
	py/emitnx64.o \
	py/asmx86.o \
	py/emitnx86.o \
	py/asmarm.o \
	py/emitnarm.o \
	py/asmxtensa.o \
	py/emitnxtensa.o \
	py/emitinlinextensa.o \
	py/emitnxtensawin.o \
	py/asmrv32.o \
	py/emitnrv32.o \
	py/emitinlinerv32.o

OBJ += $(filter-out $(addprefix $(BUILD)/, $(EXCLUDE_OBJ)), $(PY_CORE_O))
OBJ += $(addprefix $(BUILD)/, $(filter-out $(TOP)/%, $(SRC_C:.c=.o)))
OBJ += $(addprefix $(BUILD)/, $(patsubst $(TOP)/%, %, $(filter $(TOP)/%, $(SRC_C:.c=.o))))

$(BUILD)/lib/littlefs/%.o: CFLAGS += $(CFLAGS_MOD)

all: $(BUILD)/firmware.bin

$(BUILD)/firmware.elf: $(OBJ)
	$(ECHO) "LINK $@"
	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
	$(Q)$(SIZE) $@

$(BUILD)/firmware.bin: $(BUILD)/firmware.elf
	$(Q)$(OBJCOPY) -O binary $^ $@

include $(TOP)/py/mkrules.mk
