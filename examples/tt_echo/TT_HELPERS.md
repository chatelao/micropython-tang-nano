# Tiny Tapeout Helper Library (`tt.py`) Documentation

This library provides a simplified interface for interacting with Tiny Tapeout designs via the APB2 bus (Slot 1).

## Functions

### `tt.tt_init()`
Initialize TT: De-assert reset, Enable design, Clock low.

### `tt.set_clock(val)`
Set the clock state (True=High, False=Low).

### `tt.set_ui(val)`
Set the 8-bit ui_in value.

### `tt.set_uio(val)`
Set the 8-bit uio_in value.

### `tt.set_uoe(val)`
Set the 8-bit uio_oe value (Note: Current hardware may treat this as Read-Only).

### `tt.get_uo()`
Read the 8-bit uo_out value.

### `tt.get_uio()`
Read the 8-bit uio_out value.

### `tt.get_uoe()`
Read the 8-bit uio_oe value.

### `tt.send(ui, uio=None)`
Set inputs, toggle clock (High then Low), and return uo_out.
