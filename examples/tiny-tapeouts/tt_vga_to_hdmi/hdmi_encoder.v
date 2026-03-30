/*
 * Basic TMDS Encoder for DVI/HDMI output.
 * Based on DVI Spec 1.0.
 */

`default_nettype none

module tmds_encoder #(
    parameter integer CN = 0 // Channel Number (0, 1, or 2)
) (
    input  wire       clk,
    input  wire [7:0] video_data,
    input  wire [1:0] control_data,
    input  wire [3:0] island_data,
    input  wire [2:0] mode, // 0: Control, 1: Video, 2: Video Guard, 3: Island, 4: Island Guard
    output reg  [9:0] tmds
);

    // --- Video Encoding (8b/10b TMDS) ---
    wire [3:0] n1d = video_data[0] + video_data[1] + video_data[2] + video_data[3] + video_data[4] + video_data[5] + video_data[6] + video_data[7];
    wire xnor = (n1d > 4) || (n1d == 4 && video_data[0] == 0);
    wire [8:0] q_m;

    assign q_m[0] = video_data[0];
    assign q_m[1] = xnor ? (q_m[0] ^~ video_data[1]) : (q_m[0] ^ video_data[1]);
    assign q_m[2] = xnor ? (q_m[1] ^~ video_data[2]) : (q_m[1] ^ video_data[2]);
    assign q_m[3] = xnor ? (q_m[2] ^~ video_data[3]) : (q_m[2] ^ video_data[3]);
    assign q_m[4] = xnor ? (q_m[3] ^~ video_data[4]) : (q_m[3] ^ video_data[4]);
    assign q_m[5] = xnor ? (q_m[4] ^~ video_data[5]) : (q_m[4] ^ video_data[5]);
    assign q_m[6] = xnor ? (q_m[5] ^~ video_data[6]) : (q_m[5] ^ video_data[6]);
    assign q_m[7] = xnor ? (q_m[6] ^~ video_data[7]) : (q_m[6] ^ video_data[7]);
    assign q_m[8] = xnor ? 0 : 1;

    // Use an 8-bit signed counter for DC bias tracking to prevent overflow.
    reg signed [7:0] dc_bias = 0;
    wire [3:0] n1q_m = q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7];
    wire [3:0] n0q_m = 8 - n1q_m;

    reg [9:0] q_out;
    reg signed [7:0] dc_bias_next;

    always @(*) begin
        if (dc_bias == 0 || n1q_m == n0q_m) begin
            if (q_m[8] == 0) begin
                q_out = {2'b10, ~q_m[7:0]};
                dc_bias_next = dc_bias + $signed({1'b0, n0q_m}) - $signed({1'b0, n1q_m});
            end else begin
                q_out = {2'b01, q_m[7:0]};
                dc_bias_next = dc_bias + $signed({1'b0, n1q_m}) - $signed({1'b0, n0q_m});
            end
        end else begin
            if ((dc_bias > 0 && n1q_m > n0q_m) || (dc_bias < 0 && n0q_m > n1q_m)) begin
                q_out = {1'b1, q_m[8], ~q_m[7:0]};
                dc_bias_next = dc_bias + (q_m[8] ? 8'sd2 : 8'sd0) + $signed({1'b0, n0q_m}) - $signed({1'b0, n1q_m});
            end else begin
                q_out = {1'b0, q_m[8], q_m[7:0]};
                dc_bias_next = dc_bias - (~q_m[8] ? 8'sd2 : 8'sd0) + $signed({1'b0, n1q_m}) - $signed({1'b0, n0q_m});
            end
        end
    end

    // --- Control Encoding (2b/10b) ---
    reg [9:0] control_coding;
    always @(*) begin
        case (control_data)
            2'b00:   control_coding = 10'b1101010100;
            2'b01:   control_coding = 10'b0010101011;
            2'b10:   control_coding = 10'b0101010100;
            default: control_coding = 10'b1010101011;
        endcase
    end

    // --- Island Encoding (TERC4) ---
    wire [9:0] terc4_coding;
    terc4_encoder terc4_inst (
        .data(island_data),
        .tmds(terc4_coding)
    );

    // --- Video Guard Band ---
    wire [9:0] video_guard_band = (CN == 1) ? 10'b0100110011 : 10'b1011001100;

    // --- Data Island Guard Band ---
    reg [9:0] data_guard_band;
    always @(*) begin
        if (CN == 1 || CN == 2) begin
            data_guard_band = 10'b0100110011;
        end else begin
            case (control_data)
                2'b00:   data_guard_band = 10'b1010001110;
                2'b01:   data_guard_band = 10'b1001110001;
                2'b10:   data_guard_band = 10'b0101100011;
                default: data_guard_band = 10'b1011000011;
            endcase
        end
    end

    // --- Mode Selection and DC Bias Update ---
    always @(posedge clk) begin
        case (mode)
            3'd0: begin // Control
                tmds <= control_coding;
                dc_bias <= 0;
            end
            3'd1: begin // Video
                tmds <= q_out;
                dc_bias <= dc_bias_next;
            end
            3'd2: begin // Video Guard Band
                tmds <= video_guard_band;
                dc_bias <= 0;
            end
            3'd3: begin // Island
                tmds <= terc4_coding;
                dc_bias <= 0;
            end
            3'd4: begin // Island Guard Band
                tmds <= data_guard_band;
                dc_bias <= 0;
            end
            default: begin
                tmds <= control_coding;
                dc_bias <= 0;
            end
        endcase
    end

endmodule

/*
 * DVI/HDMI Encoder for Gowin (Tang Nano 4K).
 * Uses physical OSER10 primitives for serialization.
 */
module hdmi_encoder (
    input  wire        pixel_clk,    // ~25.2 MHz for 640x480
    input  wire        pixel_clk_x5, // ~126 MHz (5x for DDR serialization)
    input  wire        rst_n,        // Reset (Active Low)
    input  wire [7:0]  red,
    input  wire [7:0]  green,
    input  wire [7:0]  blue,
    input  wire        hsync_in,     // External HSync from TT module
    input  wire        vsync_in,     // External VSync from TT module
    input  wire        blank_in,     // External Blank from TT module
    input  wire [11:0] island_data,  // 4-bit per channel TERC4 data
    output wire [2:0]  tmds_p,
    output wire        tmds_clk_p,
    // Debug/Packetizer Sync
    output reg  [4:0]  packet_cnt_out,
    output wire        packet_en_out,
    output wire        hsync_out,
    output wire        vsync_out
);

    // --- Synchronization Logic ---
    reg [11:0] h_pos;
    reg hsync_d;
    always @(posedge pixel_clk) begin
        hsync_d <= hsync_in;
        if (hsync_in && !hsync_d) begin // Rising edge of HSync
            h_pos <= 0;
        end else begin
            h_pos <= h_pos + 1;
        end
    end

    // Data Island placement: during back porch (96 to 144 clocks after HSync start)
    // Data Islands occur during the blanking interval (blank_in is true)
    localparam DATA_ISLAND_START = 100;
    wire data_island_preamble = (h_pos >= DATA_ISLAND_START - 10 && h_pos < DATA_ISLAND_START - 2) && blank_in;
    wire data_island_guard    = ((h_pos >= DATA_ISLAND_START - 2  && h_pos < DATA_ISLAND_START) || (h_pos >= DATA_ISLAND_START + 32 && h_pos < DATA_ISLAND_START + 34)) && blank_in;
    wire data_island_period   = (h_pos >= DATA_ISLAND_START      && h_pos < DATA_ISLAND_START + 32) && blank_in;

    // Video Preamble and Guard Band (just before blank_in goes low)
    localparam VIDEO_START = 144;
    wire video_preamble = (h_pos >= VIDEO_START - 10 && h_pos < VIDEO_START - 2) && blank_in;
    wire video_guard    = (h_pos >= VIDEO_START - 2  && h_pos < VIDEO_START) && blank_in;

    always @(posedge pixel_clk) begin
        if (data_island_period)
            packet_cnt_out <= h_pos[4:0] - DATA_ISLAND_START[4:0];
        else
            packet_cnt_out <= 0;
    end

    assign packet_en_out  = data_island_period;
    assign hsync_out      = hsync_in;
    assign vsync_out      = vsync_in;

    // CTL signals for preambles
    wire ctl0 = video_preamble || data_island_preamble;
    wire ctl1 = 1'b0;
    wire ctl2 = data_island_preamble;
    wire ctl3 = 1'b0;

    // Mode selection (Priority order: Video -> Guard/Island/Preamble -> Control)
    reg [2:0] mode;
    always @(*) begin
        if (!blank_in)
            mode = 3'd1; // Video
        else if (video_guard)
            mode = 3'd2; // Video Guard
        else if (data_island_period)
            mode = 3'd3; // Island
        else if (data_island_guard)
            mode = 3'd4; // Island Guard
        else
            mode = 3'd0; // Control
    end

    wire [9:0] tmds_red, tmds_green, tmds_blue;
    wire [9:0] tmds_clk = 10'b1111100000;

    tmds_encoder #(.CN(2)) encode_red   (.clk(pixel_clk), .video_data(red),   .control_data({ctl3, ctl2}),   .island_data(island_data[11:8]), .mode(mode), .tmds(tmds_red));
    tmds_encoder #(.CN(1)) encode_green (.clk(pixel_clk), .video_data(green), .control_data({ctl1, ctl0}),   .island_data(island_data[7:4]),  .mode(mode), .tmds(tmds_green));
    tmds_encoder #(.CN(0)) encode_blue  (.clk(pixel_clk), .video_data(blue),  .control_data({vsync_in, hsync_in}), .island_data(island_data[3:0]),  .mode(mode), .tmds(tmds_blue));

    // Serialization using OSER10 primitives (DDR 5x clock)
    OSER10 #(
        .GSREN("false"),
        .LSREN("true")
    ) oser_red (
        .Q(tmds_p[2]),
        .D0(tmds_red[0]), .D1(tmds_red[1]), .D2(tmds_red[2]), .D3(tmds_red[3]), .D4(tmds_red[4]),
        .D5(tmds_red[5]), .D6(tmds_red[6]), .D7(tmds_red[7]), .D8(tmds_red[8]), .D9(tmds_red[9]),
        .FCLK(pixel_clk_x5),
        .PCLK(pixel_clk),
        .RESET(!rst_n)
    );

    OSER10 #(
        .GSREN("false"),
        .LSREN("true")
    ) oser_green (
        .Q(tmds_p[1]),
        .D0(tmds_green[0]), .D1(tmds_green[1]), .D2(tmds_green[2]), .D3(tmds_green[3]), .D4(tmds_green[4]),
        .D5(tmds_green[5]), .D6(tmds_green[6]), .D7(tmds_green[7]), .D8(tmds_green[8]), .D9(tmds_green[9]),
        .FCLK(pixel_clk_x5),
        .PCLK(pixel_clk),
        .RESET(!rst_n)
    );

    OSER10 #(
        .GSREN("false"),
        .LSREN("true")
    ) oser_blue (
        .Q(tmds_p[0]),
        .D0(tmds_blue[0]), .D1(tmds_blue[1]), .D2(tmds_blue[2]), .D3(tmds_blue[3]), .D4(tmds_blue[4]),
        .D5(tmds_blue[5]), .D6(tmds_blue[6]), .D7(tmds_blue[7]), .D8(tmds_blue[8]), .D9(tmds_blue[9]),
        .FCLK(pixel_clk_x5),
        .PCLK(pixel_clk),
        .RESET(!rst_n)
    );

    OSER10 #(
        .GSREN("false"),
        .LSREN("true")
    ) oser_clk (
        .Q(tmds_clk_p),
        .D0(tmds_clk[0]), .D1(tmds_clk[1]), .D2(tmds_clk[2]), .D3(tmds_clk[3]), .D4(tmds_clk[4]),
        .D5(tmds_clk[5]), .D6(tmds_clk[6]), .D7(tmds_clk[7]), .D8(tmds_clk[8]), .D9(tmds_clk[9]),
        .FCLK(pixel_clk_x5),
        .PCLK(pixel_clk),
        .RESET(!rst_n)
    );

endmodule
