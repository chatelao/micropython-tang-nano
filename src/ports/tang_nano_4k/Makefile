# Makefile for MicroPython on Tang Nano 4K

CROSS_COMPILE ?= arm-none-eabi-

CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
SIZE = $(CROSS_COMPILE)size

CFLAGS = -mcpu=cortex-m3 -mthumb -Wall -Werror -O2
CFLAGS += -I. -I../../ -I../../lib/micropython/
CFLAGS += -DNDEBUG
CFLAGS += -ffunction-sections -fdata-sections

LDFLAGS = -T tang_nano_4k.ld -Wl,--gc-sections

SRC_C = main.c \
        mphalport.c \
        uart.c

OBJ = $(SRC_C:.c=.o)

all: firmware.bin

firmware.elf: $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^
	$(SIZE) $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f *.o *.elf *.bin
