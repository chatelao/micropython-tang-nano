/* top.v - m3_ext_flash_boot */
`default_nettype none

module top (
    input  wire clk_27m,      // Pin 45

    // UART0
    output wire uart_tx,      // Pin 18
    input  wire uart_rx,      // Pin 19

    // SPI Flash (XIP)
    output wire flash_cs_n,   // Pin 36
    output wire flash_sclk,   // Pin 37
    output wire flash_mosi,   // Pin 38
    input  wire flash_miso,   // Pin 39

    output wire led_pin       // Pin 10
);

    // --- Internal Reset Logic ---
    reg [7:0] reset_cnt = 8'h0;
    wire sys_reset_n = &reset_cnt;
    always @(posedge clk_27m) begin
        if (!sys_reset_n) reset_cnt <= reset_cnt + 1'b1;
    end

    // --- AHB Expansion Bus (For Flash XIP) ---
    wire [31:0] ahb_addr;
    wire [31:0] ahb_wdata;
    wire [31:0] ahb_rdata;
    wire        ahb_write;
    wire [1:0]  ahb_trans;
    wire        ahb_ready;
    wire        ahb_hsel_flash;

    // AHB Address Decoding
    // Flash: 0x60000000
    assign ahb_hsel_flash = (ahb_addr[31:28] == 4'h6);

    wire [31:0] flash_rdata;
    wire        flash_ready;

    // AHB Data Phase Multiplexing
    assign ahb_rdata = flash_rdata;
    assign ahb_ready = ahb_hsel_flash ? flash_ready : 1'b1;

    // GPIO
    wire [15:0] m3_gpio_o;
    assign led_pin = m3_gpio_o[0];

    // --- M3 IP Core Instantiation ---
    Gowin_EMPU_M3 m3_inst (
        .SYS_CLK     (clk_27m),
        .UART0RXD    (uart_rx),
        .UART0TXD    (uart_tx),

        // AHB Expansion
        .HADDR       (ahb_addr),
        .HWDATA      (ahb_wdata),
        .HRDATA      (ahb_rdata),
        .HWRITE      (ahb_write),
        .HTRANS      (ahb_trans),
        .HREADY      (ahb_ready),

        // GPIO
        .GPIOO       (m3_gpio_o)
    );

    // --- SPI Flash Interface (AHB Bridge) ---
    // Note: For physical deployment, this MUST be the Gowin SPI Flash IP Core.
    // The following instantiation matches the standard interface.
    SPI_Flash_Interface_Top flash_inst (
        .hclk        (clk_27m),
        .hreset_n    (sys_reset_n),
        .hsel        (ahb_hsel_flash),
        // Use direct address mapping for 8MB range (23 bits)
        .haddr       ({9'h0, ahb_addr[22:0]}),
        .hwrite      (ahb_write),
        .htrans      (ahb_trans),
        .hwdata      (ahb_wdata),
        .hrdata      (flash_rdata),
        .hready      (flash_ready),

        // External Pins
        .flash_cs_n  (flash_cs_n),
        .flash_clk   (flash_sclk),
        .flash_mosi  (flash_mosi),
        .flash_miso  (flash_miso)
    );

endmodule

// Blackbox definition for Gowin SPI Flash Interface IP
module SPI_Flash_Interface_Top (
    input  wire        hclk,
    input  wire        hreset_n,
    input  wire        hsel,
    input  wire [31:0] haddr,
    input  wire        hwrite,
    input  wire [1:0]  htrans,
    input  wire [31:0] hwdata,
    output wire [31:0] hrdata,
    output wire        hready,
    output wire        flash_cs_n,
    output wire        flash_clk,
    output wire        flash_mosi,
    input  wire        flash_miso
);
endmodule
