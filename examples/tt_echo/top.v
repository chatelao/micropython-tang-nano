/*
 * Top-level module for TT Echo on Tang Nano 4K
 * Connects M3 Hard Core to TT module and exposes signals to physical pins.
 */

`default_nettype none

module top (
    input  wire clk_27m,
    input  wire rst_n,
    output wire uart_tx,
    input  wire uart_rx,

    // TT External Pins
    output wire [7:0] tt_ui_in,
    output wire [7:0] tt_uo_out,
    inout  wire [7:0] tt_uio,
    output wire       tt_ena,
    output wire       tt_clk,
    output wire       tt_rst_n
);

    // APB2 Slot 1 Signals
    wire [7:0]  paddr;
    wire        psel, penable, pwrite;
    wire [31:0] pwdata;
    wire [31:0] prdata;
    wire        pready;

    // UIO Tristate Logic
    wire [7:0] tt_uio_in;
    wire [7:0] tt_uio_out;
    wire [7:0] tt_uio_oe;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin: uio_tristate
            assign tt_uio[i] = tt_uio_oe[i] ? tt_uio_out[i] : 1'bz;
            assign tt_uio_in[i] = tt_uio[i];
        end
    endgenerate

    // TT Wrapper Instantiation
    tt_m3_wrapper tt_wrapper_inst (
        .PCLK(clk_27m),
        .PRESETn(rst_n),
        .PADDR(paddr),
        .PSEL(psel),
        .PENABLE(penable),
        .PWRITE(pwrite),
        .PWDATA(pwdata),
        .PRDATA(prdata),
        .PREADY(pready),

        .tt_ui_in(tt_ui_in),
        .tt_uo_out(tt_uo_out),
        .tt_uio_in(tt_uio_in),
        .tt_uio_out(tt_uio_out),
        .tt_uio_oe(tt_uio_oe),
        .tt_ena(tt_ena),
        .tt_clk(tt_clk),
        .tt_rst_n(tt_rst_n)
    );

    // M3 Hard Core Instantiation
    Gowin_EMPU_M3 m3_inst (
        .PSEL1(psel),
        .PENABLE1(penable),
        .PWRITE1(pwrite),
        .PADDR1({24'h0, paddr}),
        .PWDATA1(pwdata),
        .PRDATA1(prdata),
        .PREADY1(pready),

        .UART0_TXD(uart_tx),
        .UART0_RXD(uart_rx),
        .RESET_N(rst_n),
        .CLK(clk_27m)
    );

endmodule
