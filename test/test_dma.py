import machine

def test_dma():
    dma = machine.FPGADMA()
    src = bytearray([0xAA, 0x55, 0x12, 0x34])
    dst = bytearray(4)
    # Use internal SRAM address for reliability in simulation
    addr = 0x20004800

    print("DMA_START")
    # Transfer to SRAM
    dma.transfer(src, addr, 4)
    # Transfer back from SRAM
    dma.transfer(addr, dst, 4)

    if src == dst:
        print("DMA_OK")
    else:
        print("DMA_FAIL")

if __name__ == "__main__":
    test_dma()
