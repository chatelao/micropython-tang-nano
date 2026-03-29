/*
 * Top-level module for Tiny Tapeout on Tang Nano 4K
 * Integrates Cortex-M3 Hard Core with TT Wrapper and physical pins.
 */

`default_nettype none

module top (
    input  wire       clk,          // 27MHz Oscillator (Pin 45)

    // UART0 (MicroPython REPL)
    output wire       uart0_tx,     // Pin 18
    input  wire       uart0_rx,     // Pin 19

    // Tiny Tapeout External Interface
    input  wire [7:0] ui_in,        // Pins 27-34
    output wire [7:0] uo_out,       // Pins 41-44, 4-1
    inout  wire [7:0] uio,          // Pins 13-17, 20-22
    input  wire       ena,          // Pin 10
    input  wire       tt_clk,       // Pin 11
    input  wire       rst_n         // Pin 46
);

    // APB2 Expansion Bus Signals (Slot 1)
    wire        m3_pclk;
    wire        m3_presetn;
    wire [11:0] m3_paddr;
    wire        m3_psel;
    wire        m3_penable;
    wire        m3_pwrite;
    wire [31:0] m3_pwdata;
    wire [31:0] m3_prdata;
    wire        m3_pready;

    // Instantiate Gowin EMPU M3
    // Note: Port names are representative of the Gowin EMPU M3 IP configuration
    Gowin_EMPU_M3 m3_inst (
        .sys_clk   (clk),
        .uart0_tx  (uart0_tx),
        .uart0_rx  (uart0_rx),

        // APB2 Slot 1 (Base: 0x40002400)
        .pclk      (m3_pclk),
        .presetn   (m3_presetn),
        .paddr     (m3_paddr),
        .psel      (m3_psel),
        .penable   (m3_penable),
        .pwrite    (m3_pwrite),
        .pwdata    (m3_pwdata),
        .prdata    (m3_prdata),
        .pready    (m3_pready)
    );

    // Tri-state logic for Bi-directional UIO pins
    wire [7:0] uio_in_ext;
    wire [7:0] uio_out_ext;
    wire [7:0] uio_oe_ext;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_uio
            assign uio[i] = uio_oe_ext[i] ? uio_out_ext[i] : 1'bz;
            assign uio_in_ext[i] = uio[i];
        end
    endgenerate

    // TT Wrapper Instance
    tt_m3_wrapper tt_wrap_inst (
        .PCLK     (m3_pclk),
        .PRESETn  (m3_presetn),
        .PADDR    (m3_paddr[7:0]),
        .PSEL     (m3_psel),
        .PENABLE  (m3_penable),
        .PWRITE   (m3_pwrite),
        .PWDATA   (m3_pwdata),
        .PRDATA   (m3_prdata),
        .PREADY   (m3_pready),

        .ui_in_ext  (ui_in),
        .uo_out_ext (uo_out),
        .uio_in_ext (uio_in_ext),
        .uio_out_ext(uio_out_ext),
        .uio_oe_ext (uio_oe_ext),
        .ena_ext    (ena),
        .clk_ext    (tt_clk),
        .rst_n_ext  (rst_n)
    );

endmodule
