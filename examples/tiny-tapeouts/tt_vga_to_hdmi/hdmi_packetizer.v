/*
 * hdmi_packetizer.v: HDMI Audio Packetizer with ACR and ECC support.
 * Formats PCM audio (Type 0x02) and ACR (Type 0x01) into Data Island packets.
 * Complies with HDMI 1.3a bit mapping and subpacket layout.
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
    // HB0: Type, HB1: Info, HB2: Info
    // ACR (Type 0x01): HB1=0, HB2=0.
    // Audio (Type 0x02): HB1=0, HB2[3:0]=sample_present. SB0 present = 0x01.
    wire [23:0] header_data = packet_type_sel ? 24'h010002 : 24'h000001;
    wire [31:0] header_with_ecc = {
        1'b0, bch15_12(header_data[23:12]),
        1'b0, bch15_12(header_data[11:0]),
        header_data
    };

    // --- Subpacket Construction ---

    // ACR Packet (Type 0x01): N = 6144 (0x001800), CTS = 25175 (0x006257) for 25.175 MHz
    // Layout: PB0=0, PB1=CTS[19:12], PB2=CTS[11:4], PB3=CTS[3:0]<<4, PB4=N[19:12], PB5=N[11:4], PB6=N[3:0]
    // PB0=0x00, PB1=0x06, PB2=0x25, PB3=0x70, PB4=0x01, PB5=0x80, PB6=0x00
    wire [55:0] acr_sp_data = {8'h00, 8'h80, 8'h01, 8'h70, 8'h25, 8'h06, 8'h00};

    // Audio Sample Packet (Type 0x02): L-PCM, 16-bit
    // PB0: [3:0] sample_present=0x1.
    // PB1-3: Left channel (24 bits, LSB first)
    // PB4-6: Right channel (24 bits, LSB first)
    wire [55:0] audio_sp_data = {
        (r_samp[15] ? 8'hFF : 8'h00), r_samp[15:8], r_samp[7:0],
        (l_samp[15] ? 8'hFF : 8'h00), l_samp[15:8], l_samp[7:0],
        8'h01
    };

    // Construct 4 subpackets.
    wire [55:0] sp0_data = packet_type_sel ? audio_sp_data : acr_sp_data;
    wire [55:0] sp1_data = packet_type_sel ? 56'h0 : acr_sp_data;
    wire [55:0] sp2_data = packet_type_sel ? 56'h0 : acr_sp_data;
    wire [55:0] sp3_data = packet_type_sel ? 56'h0 : acr_sp_data;

    wire [63:0] sp0_with_ecc = {crc8_56(sp0_data), sp0_data};
    wire [63:0] sp1_with_ecc = {crc8_56(sp1_data), sp1_data};
    wire [63:0] sp2_with_ecc = {crc8_56(sp2_data), sp2_data};
    wire [63:0] sp3_with_ecc = {crc8_56(sp3_data), sp3_data};

    // --- Bit Mapping (HDMI 1.3a) ---
    // Pixel n carries:
    // Ch0: D0=HSync, D1=VSync, D2=Header[n], D3=SB0[n]
    // Ch1: D4=SB1[n], D5=SB2[n], D6=SB3[n], D7=SB0[n+32]
    // Ch2: D8=SB1[n+32], D9=SB2[n+32], D10=SB3[n+32]
    always @(*) begin
        island_data = 12'h000;
        island_data[0] = hsync;
        island_data[1] = vsync;

        if (packet_enable) begin
            island_data[2]  = header_with_ecc[packet_cnt];
            island_data[3]  = sp0_with_ecc[packet_cnt];
            island_data[4]  = sp1_with_ecc[packet_cnt];
            island_data[5]  = sp2_with_ecc[packet_cnt];
            island_data[6]  = sp3_with_ecc[packet_cnt];
            island_data[7]  = sp0_with_ecc[packet_cnt + 32];
            island_data[8]  = sp1_with_ecc[packet_cnt + 32];
            island_data[9]  = sp2_with_ecc[packet_cnt + 32];
            island_data[10] = sp3_with_ecc[packet_cnt + 32];
        end
    end

endmodule
