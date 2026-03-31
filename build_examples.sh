#!/bin/bash
set -e

# Function to build a bitstream
build_bitstream() {
    local name=$1
    local v_files=$2
    local cst_file=$3
    local out_fs=$4

    echo "Building bitstream for ${name}..."
    # We use splitnets -ports to ensure bus bits are separate for nextpnr/apicula compatibility
    yosys -p "read_verilog src/verilog/gowin_m3_blackbox.v ${v_files}; synth_gowin; splitnets -ports; write_json ${name}.json"

    # Fixup:
    # 1. Yosys synthesized with Gowin_EMPU_M3 (to avoid name collision with built-in EMCU)
    #    but nextpnr knows it as EMCU.
    # 2. nextpnr-gowin expects port names without brackets or dots for hard IPs (e.g. GPIOOUTEN9 instead of GPIOOUTEN [9] or GPIOOUTEN.9)
    python3 fix_json.py ${name}.json

    # Detect nextpnr executable (nextpnr-himbaechel or nextpnr-gowin)
    if command -v nextpnr-himbaechel >/dev/null 2>&1; then
        nextpnr-himbaechel --json ${name}.json \
                           --write ${name}_pnr.json \
                           --device GW1NSR-LV4CQN48PC7/I6 \
                           --vopt family=GW1NS-4 \
                           --vopt cst=${cst_file}
    elif command -v nextpnr-gowin >/dev/null 2>&1; then
        nextpnr-gowin --json ${name}.json \
                      --write ${name}_pnr.json \
                      --device GW1NSR-LV4CQN48PC7/I6 \
                      --family GW1NS-4 \
                      --cst ${cst_file}
    else
        echo "Error: nextpnr-himbaechel or nextpnr-gowin not found"
        exit 1
    fi

    gowin_pack -d GW1NS-4 -o ${out_fs} ${name}_pnr.json
    rm ${name}.json ${name}_pnr.json
}

# Ensure output directories exist
mkdir -p dist/blink dist/tt_echo dist/tt_vga_hdmi dist/neorv32 dist/serv_riscv

# 1. Blink
build_bitstream "blink" "examples/blink/blink_wrapper.v" "examples/blink/blink.cst" "dist/blink/blink.fs"

# 2. TT Echo
build_bitstream "tt_echo" "examples/tiny-tapeouts/tt_echo/tt_wrapper.v examples/tiny-tapeouts/tt_echo/tt_project.v" "examples/tiny-tapeouts/tt_echo/tt_echo.cst" "dist/tt_echo/tt_echo.fs"

# 3. TT VGA to HDMI
V_FILES_VGA="examples/tiny-tapeouts/tt_vga_to_hdmi/tt_vga_hdmi_wrapper.v \
             examples/tiny-tapeouts/tt_vga_to_hdmi/tt_project.v \
             examples/tiny-tapeouts/tt_vga_to_hdmi/hdmi_encoder.v \
             examples/tiny-tapeouts/tt_vga_to_hdmi/hdmi_packetizer.v \
             examples/tiny-tapeouts/tt_vga_to_hdmi/terc4_encoder.v \
             examples/tiny-tapeouts/tt_vga_to_hdmi/audio_dsp.v"
build_bitstream "tt_vga_hdmi" "${V_FILES_VGA}" "examples/tiny-tapeouts/tt_vga_to_hdmi/tt_vga_hdmi.cst" "dist/tt_vga_hdmi/tt_vga_hdmi.fs"

# 4. NEORV32 (Using a mock/template for now if source is missing, but script is ready)
# Note: For now, we skip if actual CPU RTL isn't present in the repo to avoid build failure.
if [ -f "examples/cpus/neorv32/neorv32_top.v" ]; then
    build_bitstream "neorv32" "examples/cpus/neorv32/neorv32_wrapper.v examples/cpus/neorv32/neorv32_top.v" "src/verilog/tang_nano_4k.cst" "dist/neorv32/neorv32.fs"
else
    echo "Skipping NEORV32 bitstream (source missing)"
    mkdir -p dist/neorv32
    cp src/fpga/bitstream/tang_nano_4k_m3.fs dist/neorv32/neorv32.fs
fi

# 5. SERV
if [ -f "examples/cpus/serv_riscv/serv_top.v" ]; then
    build_bitstream "serv" "examples/cpus/serv_riscv/serv_wrapper.v examples/cpus/serv_riscv/serv_top.v" "src/verilog/tang_nano_4k.cst" "dist/serv_riscv/serv_riscv.fs"
else
    echo "Skipping SERV bitstream (source missing)"
    mkdir -p dist/serv_riscv
    cp src/fpga/bitstream/tang_nano_4k_m3.fs dist/serv_riscv/serv_riscv.fs
fi
