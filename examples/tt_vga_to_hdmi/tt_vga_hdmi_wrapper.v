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
            4'hC:    PRDATA = {29'h0, ctrl};
            default: PRDATA = 32'h0;
        endcase
    end

    // Clock Generation
    // Pixel Clock: 25.175 MHz, Serial Clock: 251.75 MHz.
    // NOTE: To avoid undriven wires, we'll temporarily tie these to the 27M clock.
    // In a real project, you MUST instantiate an rPLL (see below).
    wire pixel_clk = CLK_27M;
    wire pixel_clk_x10 = CLK_27M; // This will NOT work for HDMI but prevents undriven warnings.

    /*
     * Concrete rPLL Template for Gowin GW1NSR-4C (Tang Nano 4K)
     * To use this, instantiate the rPLL primitive using the Gowin IP Core Generator.
     *
    rPLL #(
        .FCLKIN("27"),
        .IDIV_SEL(26), // 27 / 27 = 1
        .FBDIV_SEL(24), // 1 * 25 = 25 (Approx 25.175)
        .ODIV_SEL(2),  // VCO / 2
        .DEVICE("GW1NSR-4C")
    ) pll_inst (
        .CLKIN(CLK_27M),
        .CLKOUT(pixel_clk_x10),
        .CLKOUTD(pixel_clk),
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
    */

    // --- Tiny Tapeout Module Instantiation ---
    tt_um_vga_pattern tt_inst (
        .ui_in  (8'h00),
        .uo_out (uo_out),
        .uio_in (8'h00),
        .uio_out(),
        .uio_oe (),
        .ena    (ctrl[2]),
        .clk    (pixel_clk),
        .rst_n  (ctrl[1])
    );

    // --- VGA Signal Extraction ---
    // [7] VSync, [6] HSync, [5] Blank, [4:3] B, [2] G, [1:0] R
    wire [7:0] r_chan = {uo_out[1:0], 6'b0};
    wire [7:0] g_chan = {uo_out[2],   7'b0};
    wire [7:0] b_chan = {uo_out[4:3], 6'b0};
    wire hsync = uo_out[6];
    wire vsync = uo_out[7];
    wire blank = uo_out[5];

    // --- HDMI Encoder Instantiation ---
    hdmi_encoder hdmi_inst (
        .pixel_clk    (pixel_clk),
        .pixel_clk_x10(pixel_clk_x10),
        .red          (r_chan),
        .green        (g_chan),
        .blue         (b_chan),
        .hsync        (hsync),
        .vsync        (vsync),
        .blank        (blank),
        .tmds_p       (tmds_p),
        .tmds_clk_p   (tmds_clk_p)
    );

endmodule
