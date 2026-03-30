/*
 * Basic TMDS Encoder for DVI/HDMI output.
 * Based on DVI Spec 1.0.
 */

`default_nettype none

module tmds_encoder (
    input  wire       clk,
    input  wire [7:0] data,
    input  wire [1:0] ctrl,
    input  wire       blank,
    output reg  [9:0] tmds
);

    wire [3:0] n1d = data[0] + data[1] + data[2] + data[3] + data[4] + data[5] + data[6] + data[7];
    wire xnor = (n1d > 4) || (n1d == 4 && data[0] == 0);
    wire [8:0] q_m;

    assign q_m[0] = data[0];
    assign q_m[1] = xnor ? (q_m[0] ^~ data[1]) : (q_m[0] ^ data[1]);
    assign q_m[2] = xnor ? (q_m[1] ^~ data[2]) : (q_m[1] ^ data[2]);
    assign q_m[3] = xnor ? (q_m[2] ^~ data[3]) : (q_m[2] ^ data[3]);
    assign q_m[4] = xnor ? (q_m[3] ^~ data[4]) : (q_m[3] ^ data[4]);
    assign q_m[5] = xnor ? (q_m[4] ^~ data[5]) : (q_m[4] ^ data[5]);
    assign q_m[6] = xnor ? (q_m[5] ^~ data[6]) : (q_m[5] ^ data[6]);
    assign q_m[7] = xnor ? (q_m[6] ^~ data[7]) : (q_m[6] ^ data[7]);
    assign q_m[8] = xnor ? 0 : 1;

    // Use an 8-bit signed counter for DC bias tracking to prevent overflow.
    reg signed [7:0] dc_bias = 0;
    wire [3:0] n1q_m = q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7];
    wire [3:0] n0q_m = 8 - n1q_m;

    always @(posedge clk) begin
        if (blank) begin
            case (ctrl)
                2'b00:   tmds <= 10'b1101010100;
                2'b01:   tmds <= 10'b0010101011;
                2'b10:   tmds <= 10'b0101010100;
                default: tmds <= 10'b1010101011;
            endcase
            dc_bias <= 0;
        end else begin
            if (dc_bias == 0 || n1q_m == n0q_m) begin
                if (q_m[8] == 0) begin
                    tmds <= {2'b10, ~q_m[7:0]};
                    dc_bias <= dc_bias + $signed({1'b0, n0q_m}) - $signed({1'b0, n1q_m});
                end else begin
                    tmds <= {2'b01, q_m[7:0]};
                    dc_bias <= dc_bias + $signed({1'b0, n1q_m}) - $signed({1'b0, n0q_m});
                end
            end else begin
                if ((dc_bias > 0 && n1q_m > n0q_m) || (dc_bias < 0 && n0q_m > n1q_m)) begin
                    tmds <= {1'b1, q_m[8], ~q_m[7:0]};
                    dc_bias <= dc_bias + $signed({7'b0, q_m[8]}) + $signed({1'b0, n0q_m}) - $signed({1'b0, n1q_m});
                end else begin
                    tmds <= {1'b0, q_m[8], q_m[7:0]};
                    dc_bias <= dc_bias - $signed({7'b0, ~q_m[8]}) + $signed({1'b0, n1q_m}) - $signed({1'b0, n0q_m});
                end
            end
        end
    end

endmodule

/*
 * DVI/HDMI Encoder for Gowin (Tang Nano 4K).
 * Uses physical OSER10 primitives for serialization.
 */
module hdmi_encoder (
    input  wire        pixel_clk,    // ~25.2 MHz for 640x480
    input  wire        pixel_clk_x5, // ~126 MHz (5x for DDR serialization)
    input  wire [7:0]  red,
    input  wire [7:0]  green,
    input  wire [7:0]  blue,
    input  wire        hsync,
    input  wire        vsync,
    input  wire        blank,
    input  wire [15:0] audio_l,      // 16-bit PCM Audio (Left)
    input  wire [15:0] audio_r,      // 16-bit PCM Audio (Right)
    output wire [2:0]  tmds_p,
    output wire        tmds_clk_p
);

    wire [9:0] tmds_red, tmds_green, tmds_blue;
    wire [9:0] tmds_clk = 10'b1111100000;

    tmds_encoder encode_red   (.clk(pixel_clk), .data(red),   .ctrl(2'b00),          .blank(blank), .tmds(tmds_red));
    tmds_encoder encode_green (.clk(pixel_clk), .data(green), .ctrl(2'b00),          .blank(blank), .tmds(tmds_green));
    tmds_encoder encode_blue  (.clk(pixel_clk), .data(blue),  .ctrl({vsync, hsync}), .blank(blank), .tmds(tmds_blue));

    // Serialization using OSER10 primitives (DDR 5x clock)
    // This provides much better timing closure than a fabric shift register.
    OSER10 #(
        .GSREN("false"),
        .LSREN("true")
    ) oser_red (
        .Q(tmds_p[2]),
        .D0(tmds_red[0]), .D1(tmds_red[1]), .D2(tmds_red[2]), .D3(tmds_red[3]), .D4(tmds_red[4]),
        .D5(tmds_red[5]), .D6(tmds_red[6]), .D7(tmds_red[7]), .D8(tmds_red[8]), .D9(tmds_red[9]),
        .FCLK(pixel_clk_x5),
        .PCLK(pixel_clk),
        .RESET(1'b0)
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
        .RESET(1'b0)
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
        .RESET(1'b0)
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
        .RESET(1'b0)
    );

endmodule
