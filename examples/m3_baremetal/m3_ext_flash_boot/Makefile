# Makefile - m3_ext_flash_boot
CROSS_COMPILE ?= arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
SIZE = $(CROSS_COMPILE)size

CFLAGS = -mthumb -mcpu=cortex-m3 -O2 -Wall -g
LDFLAGS = -T ../common/m3.ld -Wl,-Map=firmware.map,--cref,--gc-sections --specs=nano.specs --specs=nosys.specs
LDFLAGS += -Wl,--defsym=MAIN_FLASH=EXT_FLASH

SRC = main.c ../common/startup.c
OBJ = $(SRC:.c=.o)

# FPGA Tools
YOSYS = yosys
NEXTPNR = nextpnr-himbaechel
GOWIN_PACK = gowin_pack

all: int_blink.bin ext_blink.bin bitstream.fs

firmware.elf: $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJ)
	$(SIZE) $@

int_blink.bin: firmware.elf
	$(OBJCOPY) -O binary -j .isr_vector $< $@

ext_blink.bin: firmware.elf
	$(OBJCOPY) -O binary -j .text -j .data $< $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

bitstream.fs: top.v top.cst
	$(YOSYS) -p "synth_gowin -top top -json top.json" top.v
	$(NEXTPNR) --device GW1NSR-LV4CQN48PC7/I6 --family GW1NS-4 --json top.json --write top_pnr.json --vopt family=GW1NS-4 --vopt device=GW1NSR-4C --cst top.cst
	$(GOWIN_PACK) -d GW1NS-4 top_pnr.json $@

clean:
	rm -f *.o *.elf *.bin *.map *.json *.fs ../common/*.o

.PHONY: all clean
