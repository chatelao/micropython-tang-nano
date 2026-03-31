/*
 * Blackbox definition for Gowin_EMPU_M3 (ARM Cortex-M3 Hard Core)
 * to allow synthesis with Yosys.
 */

(* blackbox *)
module Gowin_EMPU_M3 (
    input  wire        MSSCLK,
    input  wire        UART0RXD,
    output wire        UART0TXD,

    // AHB Expansion
    output wire [31:0] HADDR,
    output wire [31:0] HWDATA,
    input  wire [31:0] HRDATA,
    output wire        HWRITE,
    output wire [1:0]  HTRANS,
    input  wire        HREADY,

    // APB2 Expansion
    output wire        PSEL,
    output wire        PENABLE,
    output wire [11:0] PADDR,
    output wire        PWRITE,
    output wire [31:0] PWDATA,
    input  wire [31:0] PRDATA,
    input  wire        PREADY,

    // GPIO (Optional based on configuration)
    input  wire [15:0] GPIOI,
    output wire [15:0] GPIOO,
    output wire [15:0] GPIOOUTEN
);
endmodule
