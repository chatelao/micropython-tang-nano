/*
 * APB2 Wrapper for Tiny Tapeout (TT) VGA Project on Tang Nano 4K
 */

`default_nettype none

module tt_vga_hdmi_wrapper (
    input  wire        CLK_27M, // On-board crystal oscillator
    input  wire        PCLK,    // APB Clock (from M3)
    input  wire        PRESETn, // APB Reset (Active Low)
    input  wire [7:0]  PADDR,   // APB Address (Offset within slot)
    input  wire        PSEL,    // APB Select
    input  wire        PENABLE, // APB Enable
    input  wire        PWRITE,  // APB Write
    input  wire [31:0] PWDATA,  // APB Write Data
    output reg  [31:0] PRDATA,  // APB Read Data
    output wire        PREADY,  // APB Ready

    // HDMI Outputs (Differential via .cst IO_TYPE=LVDS25E)
    output wire [2:0]  tmds_p,
    output wire        tmds_clk_p
);

    assign PREADY = 1'b1;

    // Registers (W)
    reg  [2:0] ctrl;    // [1]=rst_n, [2]=ena

    // Wires from TT module (R)
    wire [7:0] uo_out;
    wire [7:0] uio_out;

    // Wires from Audio DSP
    wire [15:0] audio_pcm;
    wire        audio_strobe;

    // --- APB Write Logic ---
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            ctrl <= 3'h0;
        end else if (PSEL && PENABLE && PWRITE) begin
            if (PADDR[3:0] == 4'hC) begin
                ctrl <= PWDATA[2:0];
            end
        end
    end

    // --- APB Read Logic ---
    always @(*) begin
        case (PADDR[3:0])
            4'h0:    PRDATA = {24'h0, uo_out};
            4'h4:    PRDATA = {16'h0, audio_pcm}; // Audio PCM Read
            4'hC:    PRDATA = {29'h0, ctrl};
            default: PRDATA = 32'h0;
        endcase
    end

    // Clock Generation
    // Pixel Clock: ~25.2 MHz, Serial Clock: ~126 MHz (5x for DDR Serialization).
    wire pixel_clk;
    wire pixel_clk_x5;

    rPLL #(
        .FCLKIN("27"),
        .IDIV_SEL(2),      // 27 / 3 = 9 MHz
        .FBDIV_SEL(55),    // 9 * 56 = 504 MHz (VCO)
        .ODIV_SEL(4),      // 504 / 4 = 126 MHz (CLKOUT)
        .DEVICE("GW1NSR-4C")
    ) pll_inst (
        .CLKIN(CLK_27M),
        .CLKOUT(pixel_clk_x5),
        .CLKOUTD(),
        .RESET(1'b0),
        .RESET_P(1'b0),
        .CLKFB(1'b0),
        .FBDSEL(6'b0),
        .IDSEL(6'b0),
        .ODSEL(6'b0),
        .DUTYDA(4'b0),
        .PSDA(4'b0),
        .FDLY(4'b0)
    );

    // Use a CLKDIV primitive to get the 1/5 clock for pixel_clk
    CLKDIV #(
        .DIV_MODE("5")
    ) clk_div_inst (
        .CLKOUT(pixel_clk),
        .HCLKIN(pixel_clk_x5),
        .RESETN(ctrl[1]),
        .CALIB(1'b0)
    );

    // --- Tiny Tapeout Module Instantiation ---
    tt_um_vga_pattern tt_inst (
        .ui_in  (8'h00),
        .uo_out (uo_out),
        .uio_in (8'h00),
        .uio_out(uio_out),
        .uio_oe (),
        .ena    (ctrl[2]),
        .clk    (pixel_clk),
        .rst_n  (ctrl[1])
    );

    // --- Audio DSP Integration ---
    audio_dsp dsp_inst (
        .clk        (pixel_clk),
        .rst_n      (ctrl[1]),
        .audio_bit  (uio_out[7]),
        .pcm_out    (audio_pcm),
        .strobe_48k (audio_strobe)
    );

    // --- HDMI Infrastructure Wires ---
    wire [11:0] island_data;
    wire [4:0]  packet_cnt;
    wire        packet_enable;
    wire        hdmi_hsync, hdmi_vsync;

    // --- Audio Packetizer Instantiation ---
    hdmi_packetizer packetizer_inst (
        .clk          (pixel_clk),
        .rst_n        (ctrl[1]),
        .audio_l      (audio_pcm),
        .audio_r      (audio_pcm),
        .audio_strobe (audio_strobe),
        .packet_cnt   (packet_cnt),
        .packet_enable(packet_enable),
        .hsync        (hdmi_hsync),
        .vsync        (hdmi_vsync),
        .island_data  (island_data)
    );

    // --- Registered Buffer for Timing Closure ---
    reg [7:0] uo_out_reg;
    always @(posedge pixel_clk) begin
        uo_out_reg <= uo_out;
    end

    // --- VGA Signal Extraction (from Registered Buffer) ---
    // [7] VSync, [6] HSync, [5] Blank, [4:3] B, [2] G, [1:0] R
    wire [7:0] r_chan = {uo_out_reg[1:0], uo_out_reg[1:0], uo_out_reg[1:0], uo_out_reg[1:0]};
    wire [7:0] g_chan = {uo_out_reg[2],   uo_out_reg[2],   uo_out_reg[2],   uo_out_reg[2],
                         uo_out_reg[2],   uo_out_reg[2],   uo_out_reg[2],   uo_out_reg[2]};
    wire [7:0] b_chan = {uo_out_reg[4:3], uo_out_reg[4:3], uo_out_reg[4:3], uo_out_reg[4:3]};
    wire hsync_raw = uo_out_reg[6];
    wire vsync_raw = uo_out_reg[7];
    wire blank_raw = uo_out_reg[5];

    // --- HDMI Encoder Instantiation ---
    hdmi_encoder hdmi_inst (
        .pixel_clk     (pixel_clk),
        .pixel_clk_x5  (pixel_clk_x5),
        .rst_n         (ctrl[1]),
        .red           (r_chan),
        .green         (g_chan),
        .blue          (b_chan),
        .hsync_in      (hsync_raw),
        .vsync_in      (vsync_raw),
        .blank_in      (blank_raw),
        .island_data   (island_data),
        .tmds_p        (tmds_p),
        .tmds_clk_p    (tmds_clk_p),
        .packet_cnt_out(packet_cnt),
        .packet_en_out (packet_enable),
        .hsync_out     (hdmi_hsync),
        .vsync_out     (hdmi_vsync)
    );

endmodule
