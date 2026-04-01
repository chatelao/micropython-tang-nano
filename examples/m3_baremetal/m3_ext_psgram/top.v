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

    // --- PSRAM Memory Subsystem ---
    psram_memory psram_subsystem_inst (
        .clk         (clk_27m),
        .haddr       (ahb_addr),
        .hwdata      (ahb_wdata),
        .hrdata      (ahb_rdata),
        .hwrite      (ahb_write),
        .htrans      (ahb_trans),
        .hready      (ahb_ready)
    );

endmodule
