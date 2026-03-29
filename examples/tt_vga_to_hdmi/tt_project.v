/*
 * tt_um_vga_pattern: A simple VGA color bar generator for Tiny Tapeout.
 *
 * Signal Mapping (uo_out):
 *   [7]: VSYNC
 *   [6]: HSYNC
 *   [5]: BLANK (Active High during blanking)
 *   [4]: B
 *   [3]: B (lower bit)
 *   [2]: G
 *   [1]: R
 *   [0]: R (lower bit)
 *
 * Audio Mapping (uio_out):
 *   [7]: 440Hz Square Wave (1-bit)
 *
 * Note: This simplified mapping is used for the example to demonstrate HDMI conversion.
 */

`default_nettype none

module tt_um_vga_pattern (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Parameters for 640x480 @ 60Hz (25.175 MHz pixel clock)
    localparam H_ACTIVE      = 640;
    localparam H_FRONT_PORCH = 16;
    localparam H_SYNC_PULSE  = 96;
    localparam H_BACK_PORCH  = 48;
    localparam H_TOTAL       = 800;

    localparam V_ACTIVE      = 480;
    localparam V_FRONT_PORCH = 10;
    localparam V_SYNC_PULSE  = 2;
    localparam V_BACK_PORCH  = 33;
    localparam V_TOTAL       = 525;

    reg [9:0] h_count;
    reg [9:0] v_count;

    wire h_sync = (h_count >= (H_ACTIVE + H_FRONT_PORCH) && h_count < (H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE));
    wire v_sync = (v_count >= (V_ACTIVE + V_FRONT_PORCH) && v_count < (V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE));
    wire active = (h_count < H_ACTIVE) && (v_count < V_ACTIVE);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            h_count <= 0;
            v_count <= 0;
        end else if (ena) begin
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                if (v_count == V_TOTAL - 1) begin
                    v_count <= 0;
                end else begin
                    v_count <= v_count + 1;
                end
            end else begin
                h_count <= h_count + 1;
            end
        end
    end

    // Color bar pattern (8 vertical bars)
    reg [5:0] rgb;
    always @(*) begin
        if (!active) begin
            rgb = 6'b000000;
        end else begin
            case (h_count[9:6]) // Each bar is 64 pixels wide
                0: rgb = 6'b111111; // White
                1: rgb = 6'b111100; // Yellow
                2: rgb = 6'b001111; // Cyan
                3: rgb = 6'b001100; // Green
                4: rgb = 6'b110011; // Magenta
                5: rgb = 6'b110000; // Red
                6: rgb = 6'b000011; // Blue
                7: rgb = 6'b000000; // Black
                default: rgb = 6'b000000;
            endcase
        end
    end

    // --- Audio Generator (440Hz Square Wave) ---
    // 25.175 MHz / 440 Hz = 57216 cycles per period
    // 57216 / 2 = 28608 cycles per half-period
    reg [15:0] audio_cnt;
    reg        audio_out;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            audio_cnt <= 0;
            audio_out <= 0;
        end else if (ena) begin
            if (audio_cnt >= 28607) begin
                audio_cnt <= 0;
                audio_out <= !audio_out;
            end else begin
                audio_cnt <= audio_cnt + 1;
            end
        end
    end

    // Pin mapping: [7] VSync, [6] HSync, [5] Blank, [4] B1, [3] B0, [2] G1, [1] R1, [0] R0
    // Note: This matches the expectation of the HDMI wrapper.
    assign uo_out[7] = v_sync;
    assign uo_out[6] = h_sync;
    assign uo_out[5] = !active; // BLANK (Active High)
    assign uo_out[4] = rgb[1]; // B1
    assign uo_out[3] = rgb[0]; // B0
    assign uo_out[2] = rgb[3]; // G1
    assign uo_out[1] = rgb[5]; // R1
    assign uo_out[0] = rgb[4]; // R0

    assign uio_out = {audio_out, 7'b0000000};
    assign uio_oe  = 8'h80; // Only [7] is output

endmodule
