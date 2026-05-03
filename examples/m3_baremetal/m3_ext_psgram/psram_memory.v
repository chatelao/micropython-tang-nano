/* psram_memory.v - m3_ext_psgram */
`default_nettype none

module psram_memory (
    input  wire        clk,
    input  wire [31:0] haddr,
    input  wire [31:0] hwdata,
    output wire [31:0] hrdata,
    input  wire        hwrite,
    input  wire [1:0]  htrans,
    output wire        hready
);

    // AHB Address Decoding (PSRAM: 0x60000000)
    wire ahb_hsel_psram = (haddr[31:28] == 4'h6);

    wire [31:0] psram_rdata;
    wire        psram_ready;

    // AHB Data Phase Multiplexing
    assign hrdata = psram_rdata;
    assign hready = ahb_hsel_psram ? psram_ready : 1'b1;

    // --- PSRAM Memory Interface (AHB Bridge) ---
    // Note: For a real device, you'd use the Gowin PSRAM Controller IP.
    PSRAM_Memory_Interface psram_inst (
        .hclk        (clk),
        .hsel        (ahb_hsel_psram),
        .haddr       (haddr),
        .hwrite      (hwrite),
        .htrans      (htrans),
        .hwdata      (hwdata),
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
