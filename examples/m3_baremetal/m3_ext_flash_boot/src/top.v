module top (
    input  wire clk_27m,      // Pin 45

    inout  wire [15:0] gpio,

    // SPI Flash (XIP)
    output wire flash_cs_n,   // Pin  2
    output wire flash_hold_n, // Pin  9
    output wire flash_wp_n,   // Pin  8
    output wire flash_sclk,   // Pin  1
    inout  wire flash_mosi,   // Pin 48
    inout  wire flash_miso    // Pin 47
);

    // --- Internal Reset Logic ---
    reg [7:0] reset_cnt = 8'h0;
    wire sys_reset_n = &reset_cnt;
    always @(posedge clk_27m) begin
        if (!sys_reset_n) reset_cnt <= reset_cnt + 1'b1;
    end

// --- Interconnect Wires ---
wire        sys_clk = clk_27m;

wire        ahb_clk;
wire        ahb_rstn;
wire        ahb_sel;
wire [31:0] ahb_addr;
wire [1:0]  ahb_trans;
wire        ahb_write;
wire [31:0] ahb_hwdata;
wire [31:0] ahb_hrdata;
wire        ahb_readyout;
wire        ahb_readyin;
wire [1:0]  ahb_resp_slave;

// --- EMPU (AHB Master) ---
Gowin_EMPU_Top u_gowin_empu (
    .sys_clk(sys_clk),                   
    .gpio(gpio),
    .reset_n(sys_reset_n),

    // AHB Master Interface
    .master_hclk(ahb_clk),                  // output
    .master_hrst(ahb_rstn),                 // output
    .master_hsel(ahb_sel),                  // output
    .master_haddr(ahb_addr),                // output [31:0]
    .master_htrans(ahb_trans),              // output  [1:0]
    .master_hwrite(ahb_write),              // output
    .master_hsize(),                        // output  [2:0]
    .master_hburst(),                       // output  [2:0]
    .master_hprot(),                        // output  [3:0]
    .master_hmemattr(),                     // output  [1:0]
    .master_hexreq(),                       // output
    .master_hmaster(),                      // output  [3:0]
    .master_hwdata(ahb_hwdata),             // output [31:0]
    .master_hmastlock(),                    // output
    .master_hreadymux(ahb_readyin),         // output
    .master_hauser(),                       // output
    .master_hwuser(),                       // output  [3:0]

    // AHB Master Inputs
    .master_hrdata(ahb_hrdata),             // input  [31:0]
    .master_hreadyout(ahb_readyout),        // input
    .master_hresp(ahb_resp_slave != 2'b00), // Mappt jeden non-OKAY Status auf AHB-Lite ERROR
    .master_hexresp(1'b0),                  // input (Tie to 0)
    .master_hruser(3'b000)                  // input   [2:0] (Tie to 0)
);

// --- SPI Flash (AHB Slave) ---
SPI_Flash_Interface_Lite_Top u_spi_flash (
    // AHB Slave Interface
    .I_hclk(ahb_clk),                    // input
    .I_hresetn(ahb_rstn),                // input
    .I_hsel_reg(ahb_sel),                // input
    .I_haddr_reg(ahb_addr),              // input [31:0]
    .I_htrans_reg(ahb_trans),            // input  [1:0]
    .I_hwrite_reg(ahb_write),            // input
    .I_hwdata_reg(ahb_hwdata),           // input [31:0]
    .I_hreadyin_reg(ahb_readyin),        // input
    .O_hrdata_reg(ahb_hrdata),           // output[31:0]
    .O_hreadyout_reg(ahb_readyout),      // output
    .O_hresp_reg(ahb_resp_slave),        // output [1:0]

    .O_flash_ck(flash_sclk),             // output
    .O_flash_cs_n(flash_cs_n),           // output
    .IO_flash_hold_n(flash_hold_n),      // inout
    .IO_flash_wp_n(flash_wp_n),          // inout
    .IO_flash_do(flash_mosi),            // inout
    .IO_flash_di(flash_miso)             // inout
);

endmodule
