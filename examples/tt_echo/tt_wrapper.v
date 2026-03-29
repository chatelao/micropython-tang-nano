/*
 * APB2 Wrapper for Tiny Tapeout (TT) on Tang Nano 4K
 *
 * This wrapper connects a standard TT module to the M3 APB2 expansion bus (Slot 1)
 * AND exposes the signals to external FPGA pins.
 *
 * Register Map (Base: 0x40002400):
 *   0x00: DATA    (W: ui_in_m3, R: uo_out)
 *   0x04: UIO_DATA (W: uio_in_m3, R: uio_out)
 *   0x08: UIO_OE   (R: uio_oe)
 *   0x0C: CTRL     (W/R: [0]=clk_m3, [1]=rst_n_m3, [2]=ena_m3)
 */

`default_nettype none

module tt_m3_wrapper (
    input  wire        PCLK,    // APB Clock (from M3)
    input  wire        PRESETn, // APB Reset (Active Low)
    input  wire [7:0]  PADDR,   // APB Address (Offset within slot)
    input  wire        PSEL,    // APB Select
    input  wire        PENABLE, // APB Enable
    input  wire        PWRITE,  // APB Write
    input  wire [31:0] PWDATA,  // APB Write Data
    output reg  [31:0] PRDATA,  // APB Read Data
    output wire        PREADY,  // APB Ready

    // External Pin Interface
    input  wire [7:0]  ui_in_ext,
    output wire [7:0]  uo_out_ext,
    input  wire [7:0]  uio_in_ext,
    output wire [7:0]  uio_out_ext,
    output wire [7:0]  uio_oe_ext,
    input  wire        ena_ext,
    input  wire        clk_ext,
    input  wire        rst_n_ext
);

    assign PREADY = 1'b1;

    // Registers (W from M3)
    reg  [7:0] ui_in_m3;
    reg  [7:0] uio_in_m3;
    reg  [2:0] ctrl_m3;    // [0]=clk, [1]=rst_n, [2]=ena

    // Combined Signals to TT module
    wire [7:0] ui_in   = ui_in_m3 | ui_in_ext;
    wire [7:0] uio_in  = uio_in_m3 | uio_in_ext;
    wire       ena     = ctrl_m3[2] | ena_ext;
    wire       clk     = ctrl_m3[0] | clk_ext;
    wire       rst_n   = ctrl_m3[1] & rst_n_ext;

    // Wires from TT module (R)
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // Route outputs to external pins
    assign uo_out_ext  = uo_out;
    assign uio_out_ext = uio_out;
    assign uio_oe_ext  = uio_oe;

    // --- APB Write Logic ---
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            ui_in_m3   <= 8'h0;
            uio_in_m3  <= 8'h0;
            ctrl_m3    <= 3'h0; // Reset active (rst_n=0), Ena=0, Clk=0
        end else if (PSEL && PENABLE && PWRITE) begin
            case (PADDR[3:0])
                4'h0: ui_in_m3  <= PWDATA[7:0];
                4'h4: uio_in_m3 <= PWDATA[7:0];
                4'hC: ctrl_m3   <= PWDATA[2:0];
            endcase
        end
    end

    // --- APB Read Logic ---
    always @(*) begin
        case (PADDR[3:0])
            4'h0:    PRDATA = {24'h0, uo_out};
            4'h4:    PRDATA = {24'h0, uio_out};
            4'h8:    PRDATA = {24'h0, uio_oe};
            4'hC:    PRDATA = {29'h0, ctrl_m3};
            default: PRDATA = 32'h0;
        endcase
    end

    // --- Tiny Tapeout Module Instantiation ---
    tt_um_minimal_echo tt_inst (
        .ui_in  (ui_in),
        .uo_out (uo_out),
        .uio_in (uio_in),
        .uio_out(uio_out),
        .uio_oe (uio_oe),
        .ena    (ena),
        .clk    (clk),
        .rst_n  (rst_n)
    );

endmodule
