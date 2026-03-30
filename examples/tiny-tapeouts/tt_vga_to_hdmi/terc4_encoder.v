/*
 * TERC4 (TMDS Error Reduction Coding) Encoder for HDMI.
 * Maps 4-bit data to 10-bit TMDS words for Data Island packets.
 * Based on HDMI Spec 1.3/1.4.
 */

`default_nettype none

module terc4_encoder (
    input  wire [3:0] data,
    output reg  [9:0] tmds
);

    always @(*) begin
        case (data)
            4'b0000: tmds = 10'b1010011100;
            4'b0001: tmds = 10'b1001100011;
            4'b0010: tmds = 10'b1011100100;
            4'b0011: tmds = 10'b1011100010;
            4'b0100: tmds = 10'b0101110001;
            4'b0101: tmds = 10'b0100011110;
            4'b0110: tmds = 10'b0110001110;
            4'b0111: tmds = 10'b0100111100;
            4'b1000: tmds = 10'b1011001100;
            4'b1001: tmds = 10'b0100111001;
            4'b1010: tmds = 10'b0110011100;
            4'b1011: tmds = 10'b1011000110;
            4'b1100: tmds = 10'b1010001110;
            4'b1101: tmds = 10'b1001110001;
            4'b1110: tmds = 10'b0101100011;
            4'b1111: tmds = 10'b1011000011;
        endcase
    end

endmodule
