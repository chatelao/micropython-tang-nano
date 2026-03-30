import machine

# Tiny Tapeout is mapped to APB2 Slot 1
TT_BASE  = 0x40002400
REG_DATA = TT_BASE + 0x00
REG_UIO  = TT_BASE + 0x04
REG_OE   = TT_BASE + 0x08
REG_CTRL = TT_BASE + 0x0C

def tt_init():
    """Initialize TT: De-assert reset, Enable design, Clock low."""
    # CTRL: [0]=clk, [1]=rst_n, [2]=ena
    machine.mem32[REG_CTRL] = 0x6 # rst_n=1, ena=1, clk=0

def set_clock(val):
    """Set the clock state (True=High, False=Low)."""
    ctrl = machine.mem32[REG_CTRL]
    if val:
        machine.mem32[REG_CTRL] = ctrl | 0x1
    else:
        machine.mem32[REG_CTRL] = ctrl & ~0x1

def set_ui(val):
    """Set the 8-bit ui_in value."""
    machine.mem32[REG_DATA] = val & 0xFF

def set_uio(val):
    """Set the 8-bit uio_in value."""
    machine.mem32[REG_UIO] = val & 0xFF

def set_uoe(val):
    """Set the 8-bit uio_oe value (Note: Current hardware may treat this as Read-Only)."""
    machine.mem32[REG_OE] = val & 0xFF

def get_uo():
    """Read the 8-bit uo_out value."""
    return machine.mem32[REG_DATA] & 0xFF

def get_uio():
    """Read the 8-bit uio_out value."""
    return machine.mem32[REG_UIO] & 0xFF

def get_uoe():
    """Read the 8-bit uio_oe value."""
    return machine.mem32[REG_OE] & 0xFF

def send(ui, uio=None):
    """Set inputs, toggle clock (High then Low), and return uo_out."""
    set_ui(ui)
    if uio is not None:
        set_uio(uio)

    set_clock(True)
    set_clock(False)

    return get_uo()
