/*
 * SERV RISC-V Wrapper for Tang Nano 4K (GW1NSR-4C)
 *
 * This wrapper connects the bit-serial SERV core to the M3's APB2 expansion bus.
 *
 * M3 Side (MicroPython):
 *   machine.mem32[0x40002D00] = 0x1 (Reset SERV)
 *   machine.mem32[0x40002D00] = 0x2 (Enable SERV)
 *   result = machine.mem32[0x40002D08] (Read RISC-V 'a0' register)
 */

`default_nettype none

module serv_m3_wrapper (
    input  wire        PCLK,    // APB Clock (from M3)
    input  wire        PRESETn, // APB Reset (Active Low)
    input  wire [7:0]  PADDR,   // APB Address (Offset within slot)
    input  wire        PSEL,    // APB Select
    input  wire        PENABLE, // APB Enable
    input  wire        PWRITE,  // APB Write
    input  wire [31:0] PWDATA,  // APB Write Data
    output reg  [31:0] PRDATA,  // APB Read Data
    output wire        PREADY   // APB Ready
);

    assign PREADY = 1'b1; // Always ready for simplicity

    // --- SERV Control/Status Registers ---
    reg [31:0] ctrl_reg;   // 0x00: [0]=Reset, [1]=Enable
    reg [31:0] status_reg; // 0x04: [0]=Halted
    reg [31:0] result_reg; // 0x08: RISC-V a0

    // --- Instruction Memory (64 bytes) ---
    reg [31:0] imem [0:15];

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            ctrl_reg <= 32'h1; // Start in reset
            status_reg <= 32'h0;
            result_reg <= 32'h0;
        end else if (PSEL && PENABLE) begin
            if (PWRITE) begin
                if (PADDR[7:6] == 2'b00) begin
                    case (PADDR[5:0])
                        6'h00: ctrl_reg <= PWDATA;
                        // Status and Result are Read-Only for M3
                    endcase
                end else if (PADDR[7:6] == 2'b01) begin // 0x40 and above
                    imem[PADDR[5:2]] <= PWDATA;
                end
            end else begin
                if (PADDR[7:6] == 2'b00) begin
                    case (PADDR[5:0])
                        6'h00: PRDATA <= ctrl_reg;
                        6'h04: PRDATA <= status_reg;
                        6'h08: PRDATA <= result_reg;
                        default: PRDATA <= 32'h0;
                    endcase
                end else if (PADDR[7:6] == 2'b01) begin
                    PRDATA <= imem[PADDR[5:2]];
                end else begin
                    PRDATA <= 32'h0;
                end
            end
        end
    end

    // --- SERV Core Instantiation ---
    // Note: To use the real SERV core, you must include the serv_top.v
    // and its dependencies in your Gowin project and uncomment below.
    /*
    serv_top #(
        .RESET_PC(32'h00000000)
    ) cpu (
        .clk    (PCLK),
        .i_rst  (ctrl_reg[0]),
        .i_en   (ctrl_reg[1]),
        .o_halt (status_reg[0]),
        .o_a0   (result_reg),
        // ... Instruction and Data Memory interfaces connected to 'imem' and other fabric resources ...
    );
    */

endmodule
