.PHONY: all setup build test clean

all: build

setup:
	./scripts/setup.sh

build:
	./scripts/build.sh

test:
	./scripts/test.sh

clean:
	make -C src/lib/micropython/mpy-cross clean
	make -C src/ports/tang_nano_4k/ clean
