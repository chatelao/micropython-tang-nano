/*
 * NEORV32 (RISC-V) to M3 Bridge (Verilog Template)
 *
 * This wrapper shows how to connect the NEORV32 RISC-V processor to the
 * ARM Cortex-M3 (Hard Core) on the GW1NSR-4C SoC.
 */

`default_nettype none

module neorv32_m3_wrapper (
    input  wire clk,
    input  wire rst_n
);

    // --- M3 IP Interfacing Signals ---
    // These signals are connected to the 'Gowin_EMPU_M3' IP core ports.

    // AHB-Lite Master (from M3 to FPGA fabric)
    // Used to route M3 AHB requests to the FPGA bridge
    wire [31:0] m3_ahb_addr;
    wire [31:0] m3_ahb_wdata;
    wire [31:0] m3_ahb_rdata;
    wire        m3_ahb_write;
    wire [1:0]  m3_ahb_trans;
    wire        m3_ahb_ready;

    // APB2 Expansion Interface (from M3 to FPGA fabric)
    // We'll use Slot 1 (0x40002400) for control and status registers.
    wire [7:0]  m3_apb2_paddr;   // Slot-relative address (0x00 - 0xFF)
    wire [31:0] m3_apb2_pwdata;
    wire [31:0] m3_apb2_prdata;
    wire        m3_apb2_psel;    // Slot 1 select signal
    wire        m3_apb2_penable;
    wire        m3_apb2_pwrite;
    wire        m3_apb2_pready;

    // --- NEORV32 Control and Status Registers (APB2 Slot 1) ---
    reg [31:0] riscv_ctrl;   // Bit 0: Reset (1: Reset, 0: Run)
    reg [31:0] m3_to_riscv;  // Mailbox from M3 to RISC-V
    wire [31:0] riscv_to_m3; // Mailbox from RISC-V to M3

    // APB2 Read Access for Slot 1
    assign m3_apb2_prdata = (m3_apb2_paddr == 8'h00) ? riscv_ctrl :
                            (m3_apb2_paddr == 8'h04) ? riscv_to_m3 :
                            (m3_apb2_paddr == 8'h08) ? m3_to_riscv : 32'h0;
    assign m3_apb2_pready = 1'b1;

    // APB2 Write Access for Slot 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            riscv_ctrl  <= 32'h01; // Default to Reset
            m3_to_riscv <= 32'h0;
        end else if (m3_apb2_psel && m3_apb2_penable && m3_apb2_pwrite) begin
            case (m3_apb2_paddr)
                8'h00: riscv_ctrl  <= m3_apb2_pwdata;
                8'h08: m3_to_riscv <= m3_apb2_pwdata;
            endcase
        end
    end

    // --- NEORV32 Core Instantiation ---
    // Note: This is a template. You must include the neorv32 core files in your project.
    /*
    neorv32_top #(
        .CLOCK_FREQUENCY (27000000),
        .CPU_EXTENSION_RISCV_M (1),
        .CPU_EXTENSION_RISCV_A (1),
        .CPU_EXTENSION_RISCV_C (1),
        .MEM_INT_IMEM_SIZE (0), // No internal IMEM, use external PSRAM
        .MEM_INT_DMEM_SIZE (0)  // No internal DMEM, use external PSRAM
    ) my_neorv32 (
        .clk_i (clk),
        .rstn_i (rst_n & ~riscv_ctrl[0]), // M3-controlled reset

        // Instruction and Data Bus (WB or AXI)
        // You would typically bridge these to the M3's AHB/PSRAM interface.
        // ... (Bus wiring to PSRAM at 0xA0000000) ...

        // Mailbox Interface (using the NEORV32 external interrupts or GPIOs)
        .ext_irq_i (1'b0),
        .gpio_i ({m3_to_riscv[7:0], 24'h0}),
        .gpio_o (riscv_to_m3)
    );
    */

endmodule
