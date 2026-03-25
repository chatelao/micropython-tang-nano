import machine
import time

dma = machine.FPGADMA()
SRAM_TEST_ADDR = 0x20004000
src_data = bytearray([0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88])
dest_data = bytearray(8)
print("DMA_START")
dma.transfer(src_data, SRAM_TEST_ADDR, 8)
dma.transfer(SRAM_TEST_ADDR, dest_data, 8)

# Simpler way to print hex
hex_str = ""
for b in dest_data:
    hex_str += "%02X" % b
print("DATA:", hex_str)

if src_data == dest_data:
    print("DMA_OK")
else:
    print("DMA_FAIL")
