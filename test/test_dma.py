import machine
import time

dma = machine.FPGADMA()
src = bytearray([0xAA, 0x55, 0x12, 0x34, 0x56, 0x78, 0x90, 0xEF])
dst = bytearray(8)
addr = 0x20004800

print("DMA_START")
dma.transfer(src, addr, 8)
dma.transfer(addr, dst, 8)

if src == dst:
    print("DMA_OK")
else:
    print("DMA_FAIL")
