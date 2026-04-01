/* top.v - m3_ext_psgram */
`default_nettype none

module top (
    input  wire clk_27m,      // Pin 45
    output wire led_pin       // Pin 10
);

    // --- AHB Expansion Bus (For PSRAM) ---
    wire [31:0] ahb_addr;
    wire [31:0] ahb_wdata;
    wire [31:0] ahb_rdata;
    wire        ahb_write;
    wire [1:0]  ahb_trans;
    wire        ahb_ready;
    wire        ahb_hsel_psram;

    // AHB Address Decoding (PSRAM: 0xA0000000)
    assign ahb_hsel_psram = (ahb_addr[31:28] == 4'hA);

    wire [31:0] psram_rdata;
    wire        psram_ready;

    // AHB Data Phase Multiplexing
    assign ahb_rdata = psram_rdata;
    assign ahb_ready = ahb_hsel_psram ? psram_ready : 1'b1;

    // GPIO
    wire [15:0] m3_gpio_o;
    assign led_pin = m3_gpio_o[0];

    // --- M3 IP Core Instantiation ---
    Gowin_EMPU_M3 m3_inst (
        .SYS_CLK     (clk_27m),

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

    // --- PSRAM Memory Interface (AHB Bridge) ---
    // Note: For a real device, you'd use the Gowin PSRAM Controller IP.
    PSRAM_Memory_Interface psram_inst (
        .hclk        (clk_27m),
        .hsel        (ahb_hsel_psram),
        .haddr       (ahb_addr),
        .hwrite      (ahb_write),
        .htrans      (ahb_trans),
        .hwdata      (ahb_wdata),
        .hrdata      (psram_rdata),
        .hready      (psram_ready)
    );

endmodule

// This would typically be a Gowin IP core.
module PSRAM_Memory_Interface (
    input  wire        hclk,
    input  wire        hsel,
    input  wire [31:0] haddr,
    input  wire        hwrite,
    input  wire [1:0]  htrans,
    input  wire [31:0] hwdata,
    output wire [31:0] hrdata,
    output wire        hready
);
    // Simple AHB-Lite PSRAM Emulator
    reg [31:0] ram [0:255]; // Tiny RAM for testing
    wire [7:0] index = haddr[9:2];

    always @(posedge hclk) begin
        if (hsel && hwrite && htrans[1]) begin
            ram[index] <= hwdata;
        end
    end

    assign hrdata = ram[index];
    assign hready = 1'b1;
endmodule
