.PHONY: all setup build test clean

all: build

setup:
	./scripts/setup.sh

build:
	./scripts/build.sh

test:
	./scripts/test.sh

clean:
	@if [ -d src/lib/micropython/mpy-cross ]; then make -C src/lib/micropython/mpy-cross clean; fi
	@if [ -d src/ports/tang_nano_4k/ ]; then make -C src/ports/tang_nano_4k/ clean; fi
