# Roadmap: Tiny Tapeout VGA to HDMI Adapter

This roadmap outlines the implementation of a full VGA-to-HDMI bridge for Tiny Tapeout (TT) projects on the Tang Nano 4K (Gowin GW1NSR-4C). It includes video, audio, and physical layer optimization.

---

## 1. Clock Generation (PLL)
**Goal:** Generate a stable 25.175 MHz pixel clock and a 10x or 5x (DDR) serial clock.

### Approaches
| Approach | Description | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **A: Fabric PLL** | Use a manual Verilog implementation of a frequency synthesizer. | Flexible, toolchain independent. | High jitter, poor timing closure at high speeds. |
| **B: Gowin rPLL IP** | Use the native `rPLL` primitive via Gowin IP Core Generator. | **Best stability**, low jitter, phase-locked clocks. | Toolchain dependent (requires Gowin EDA). |
| **C: External Clock** | Use an external oscillator to provide both clocks. | Zero FPGA resource usage for clocks. | Requires hardware modification or external parts. |

**Selected Approach:** **B (Gowin rPLL IP)** for its stability and native hardware support.

### Subtasks
- [x] Instantiate `rPLL` primitive in `tt_vga_hdmi_wrapper.v`.
- [x] Configure `FCLKIN=27MHz`, `CLKOUTD=25.175MHz`, `CLKOUT=125.875MHz` (for 5x DDR).

### Tests
- **Simulation:** Verify clock ratios in Icarus Verilog or Verilator.
- **Hardware:** Observe `pixel_clk` on an output pin using an oscilloscope.

---

## 2. Video Signal Integration
**Goal:** Interface the TT module's 8-bit output with the HDMI encoder.

### Approaches
| Approach | Description | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **A: Direct Wire** | Connect `uo_out` directly to the encoder inputs. | Zero latency. | No control over synchronization/timing. |
| **B: Registered Buffer**| Pass `uo_out` through a flip-flop stage synced to `pixel_clk`. | **Improved timing closure**, stable signals. | 1-clock cycle latency. |
| **C: Asynchronous FIFO**| Use a FIFO to cross from TT clock domain to HDMI clock domain. | Robust against clock skew. | High resource usage (Block RAM). |

**Selected Approach:** **B (Registered Buffer)** to balance timing stability and resource usage.

### Subtasks
- [x] Update `tt_vga_hdmi_wrapper.v` to register `uo_out` at the `pixel_clk` edge.
- [x] Extract `hsync`, `vsync`, `blank`, and `rgb` from the registered signals.

### Tests
- **Simulation:** Check signal alignment between `pixel_clk` and `uo_out`.
- [x] **Renode:** Verify `PRDATA` reflects the TT output accurately.

---

## 3. Color Mapping (Bit-Padding)
**Goal:** Convert 2-bit TT color channels to 8-bit HDMI channels.

### Approaches
| Approach | Description | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **A: Zero Padding** | Shift 2-bits left and pad with 6 zeros (e.g., `11` -> `11000000`). | Simplest logic. | Lower maximum brightness (192 instead of 255). |
| **B: Bit Replication**| Replicate the 2 bits four times (e.g., `11` -> `11111111`). | **Full dynamic range (0-255)**, no math needed. | None. |
| **C: Gamma LUT** | Use a Look-Up Table to map 2-bits to 8-bits with gamma correction. | Best visual quality. | Uses LUT/BRAM resources. |

**Selected Approach:** **B (Bit Replication)** for efficiency and full brightness.

### Subtasks
- [x] Implement `{color_2bit, color_2bit, color_2bit, color_2bit}` concatenation in the wrapper.

### Tests
- [x] **Simulation:** Verify that `2'b11` maps to `8'hFF`. (Implemented in wrapper)

---

## 4. Audio DSP (1-bit to PCM)
**Goal:** Convert the 1-bit PWM/PDM audio from TT to 16-bit L-PCM for HDMI.

### Approaches
| Approach | Description | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **A: Moving Average** | Sum 1-bit samples over a fixed window (e.g., 524 samples). | Very low resource usage. | High-frequency noise aliasing. |
| **B: CIC Filter** | Cascaded Integrator-Comb filter for decimation. | **Steep roll-off**, efficient for high decimation. | Requires multi-stage registers. |
| **C: FIR Filter** | Full Finite Impulse Response filter with coefficients. | Best audio quality, flat response. | Extremely high resource usage (DSP blocks). |

**Selected Approach:** **B (CIC Filter)** as it provides the best trade-off between quality and resource usage on the GW1NSR-4C.

### Subtasks
- [x] Implement a 2-stage CIC filter in Verilog.
- [x] Normalize the output to 16-bit signed PCM.
- [x] Implement a 48kHz sampling clock trigger.

### Tests
- [x] **Simulation:** Feed a 50% PWM signal and verify it results in a steady-state PCM value.
- **Hardware:** Listen for clear tones on the HDMI audio channel.

---

## 5. HDMI Protocol & Data Island Packaging
**Goal:** Pack video and audio into standard HDMI frames.

### Approaches
| Approach | Description | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **A: DVI-Only** | Only implement TMDS video encoding. | Low logic usage. | No audio support. |
| **B: Custom TERC4** | Manually implement TERC4 encoding and Packetizer. | **Deep understanding, optimized**. | High complexity, error-prone. |
| **C: hdl-util/hdmi** | Integrate the standard `hdl-util/hdmi` SystemVerilog core. | Feature complete (Audio, InfoFrames). | High LUT usage (~800-1000). |

**Selected Approach:** **B (Custom TERC4/Packetizer)** for maximum control and resource efficiency on the GW1NSR-4C.

### Subtasks
- [x] Implement TERC4 encoder in `terc4_encoder.v`.
- [x] Implement HDMI Packetizer for Audio and ACR in `hdmi_packetizer.v`.
- [x] Configure ACR (Audio Clock Regeneration) parameters for 25.175MHz (N=6144, CTS=25175).
- [x] Implement Data Island bit mapping (Header + 4 Subpackets) in the packetizer.

### Tests
- [x] **Simulation:** Verify Data Island bit mapping and ECC (BCH/CRC) in `hdmi_packetizer.v` via `run_sim.sh`.

---

## 6. Physical Layer Serialization
**Goal:** Convert 10-bit TMDS words to serial differential signals.

### Approaches
| Approach | Description | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **A: Fabric Shift Reg** | Use standard Verilog shift registers at 251MHz. | Portable. | Likely to fail timing on Tang Nano 4K. |
| **B: OSER10 DDR** | Use Gowin `OSER10` primitive with a 5x clock. | **High performance**, guaranteed timing. | Hardware specific. |
| **C: LVDS Output** | Use `TLVDS_OBUF` for direct differential driving. | Correct electrical levels. | Requires 10x clock if not using OSER. |

**Selected Approach:** **B (OSER10 DDR)** combined with LVDS25E IO_TYPE.

### Subtasks
- [x] Instantiate 4x `OSER10` primitives (R, G, B, CLK).
- [x] Map outputs to pins 35, 32, 30, 28 in `tt_vga_hdmi.cst`.

### Tests
- **Hardware:** Use a logic analyzer or oscilloscope to verify the 251.75 Mbps bit rate.

---

## 7. Verification & Testing
**Goal:** Ensure the system works as a whole.

### Approaches
| Approach | Description | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **A: Signal Prob** | Map internal signals to FPGA header pins for observation. | Real-time debug. | Limited by pin count and bandwidth. |
| **B: Renode Simulation**| Use Renode to mock the HDMI registers and test the M3 interface. | **Automated CI**, verifies software control. | Does not verify high-speed PHY. |
| **C: Hardware Test** | Connect to a physical HDMI monitor. | Final verification. | Hard to debug if it fails (black screen). |

**Selected Approach:** **Combined B and C**.

### Subtasks
- Create a `test_tt_vga_hdmi.robot` test in Renode.
- Implement a MicroPython script to toggle the TT module and check status.

### Tests
- **Renode:** Confirm that `machine.mem32` can enable/disable the HDMI stream via the APB2 bridge.
- **Hardware:** Display 8 color bars and play a 440Hz test tone on a TV.
