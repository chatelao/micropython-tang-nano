import machine
import time

# Tiny Tapeout VGA to HDMI Controller
# Base address for APB2 Slot 1: 0x40002400
# Register Map:
#   0x00: DATA (R: uo_out)
#   0x04: AUDIO (R: 16-bit PCM)
#   0x0C: CTRL (W/R: [0]=clk, [1]=rst_n, [2]=ena)

TT_BASE = 0x40002400
TT_DATA = TT_BASE + 0x00
TT_AUDIO = TT_BASE + 0x04
TT_CTRL = TT_BASE + 0x0C

def enable_tt():
    """Release reset and enable the TT module."""
    print("Enabling Tiny Tapeout module...")
    # Release reset (bit 1) and enable (bit 2)
    # 0x6 = 0b110
    machine.mem32[TT_CTRL] = 0x6
    print("TT module enabled.")

def disable_tt():
    """Put the TT module into reset and disable it."""
    print("Disabling Tiny Tapeout module...")
    machine.mem32[TT_CTRL] = 0x0
    print("TT module disabled.")

def check_status():
    """Read and print the current output from the TT module."""
    uo_out = machine.mem32[TT_DATA] & 0xFF
    audio_pcm = machine.mem32[TT_AUDIO] & 0xFFFF
    # Convert to signed 16-bit
    if audio_pcm > 32767:
        audio_pcm -= 65536

    print(f"uo_out: {hex(uo_out)}")
    print(f"VSYNC: { (uo_out >> 7) & 1 }")
    print(f"HSYNC: { (uo_out >> 6) & 1 }")
    print(f"Audio PCM: {audio_pcm}")

if __name__ == "__main__":
    disable_tt()
    time.sleep(0.1)
    enable_tt()

    # Give it a second to start generating frames and audio samples
    time.sleep(1)
    check_status()
