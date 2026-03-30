/*
 * hdmi_packetizer.v: HDMI Audio Packetizer with ACR and ECC support.
 * Formats PCM audio (Type 0x02) and ACR (Type 0x01) into Data Island packets.
 */

`default_nettype none

module hdmi_packetizer (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] audio_l,
    input  wire [15:0] audio_r,
    input  wire        audio_strobe,
    input  wire [4:0]  packet_cnt,   // 0 to 31
    input  wire        packet_enable,
    input  wire        hsync,
    input  wire        vsync,
    output reg  [11:0] island_data
);

    // --- Audio Buffer ---
    reg [15:0] l_samp, r_samp;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            l_samp <= 0;
            r_samp <= 0;
        end else if (audio_strobe) begin
            l_samp <= audio_l;
            r_samp <= audio_r;
        end
    end

    // --- Packet Type Selection ---
    // Alternate between ACR (Type 0x01) and Audio Sample (Type 0x02)
    // Audio samples are sent every line (~31.5kHz). ACR should be frequent.
    reg packet_type_sel;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            packet_type_sel <= 0;
        end else if (packet_cnt == 31) begin
            packet_type_sel <= !packet_type_sel;
        end
    end

    // --- BCH(15,12) for Header ---
    function [2:0] bch15_12;
        input [11:0] d;
        begin
            bch15_12[0] = d[0] ^ d[2] ^ d[3] ^ d[5] ^ d[6] ^ d[8] ^ d[9] ^ d[11];
            bch15_12[1] = d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[6] ^ d[7] ^ d[9] ^ d[10];
            bch15_12[2] = d[1] ^ d[2] ^ d[4] ^ d[5] ^ d[7] ^ d[8] ^ d[10] ^ d[11];
        end
    endfunction

    // --- CRC-8 for Subpackets ---
    function [7:0] crc8_56;
        input [55:0] d;
        reg [7:0] c;
        integer i;
        begin
            c = 8'h00;
            for (i = 0; i < 56; i = i + 1) begin
                if (d[i] ^ c[7])
                    c = (c << 1) ^ 8'h07;
                else
                    c = (c << 1);
            end
            crc8_56 = c;
        end
    endfunction

    // --- Header Construction ---
    wire [23:0] header_data = packet_type_sel ? 24'h001002 : 24'h000001;
    wire [31:0] header_with_ecc = {
        1'b0, bch15_12(header_data[23:12]),
        1'b0, bch15_12(header_data[11:0]),
        header_data
    };

    // --- Subpacket Construction ---
    // ACR Packet (Type 0x01): N = 6144 (0x001800), CTS = 25200 (0x006270)
    // Subpacket 0-3 share the same ACR data in different layouts.
    wire [55:0] acr_data = {8'h00, 24'h001800, 24'h006270};

    // Audio Sample Packet (Type 0x02):
    wire [55:0] sp_data = {8'h00, r_samp, 8'h00, l_samp};

    wire [55:0] current_sp_data = packet_type_sel ? sp_data : acr_data;
    wire [63:0] sp_with_ecc = {crc8_56(current_sp_data), current_sp_data};

    // --- Bit Mapping ---
    always @(*) begin
        island_data = 12'h0;
        island_data[0] = hsync;
        island_data[1] = vsync;

        if (packet_enable) begin
            island_data[2]   = header_with_ecc[packet_cnt];
            island_data[3]   = sp_with_ecc[packet_cnt];
            island_data[6]   = sp_with_ecc[packet_cnt + 32];
        end
    end

endmodule
