/*
 * tb_hdmi_packetizer.v: Testbench for the HDMI Audio Packetizer.
 * Verifies protocol compliance (HB, SB bit mapping) and ACR parameters.
 */

`timescale 1ns/1ps
`default_nettype none

module tb_hdmi_packetizer;

    reg clk;
    reg rst_n;
    reg [15:0] audio_l;
    reg [15:0] audio_r;
    reg audio_strobe;
    reg [4:0] packet_cnt;
    reg packet_enable;
    reg hsync;
    reg vsync;

    wire [11:0] island_data;

    // Instantiate UUT
    hdmi_packetizer uut (
        .clk(clk),
        .rst_n(rst_n),
        .audio_l(audio_l),
        .audio_r(audio_r),
        .audio_strobe(audio_strobe),
        .packet_cnt(packet_cnt),
        .packet_enable(packet_enable),
        .hsync(hsync),
        .vsync(vsync),
        .island_data(island_data)
    );

    // Clock generation
    always #20 clk = ~clk; // ~25 MHz

    integer i;
    reg [31:0] captured_header;
    reg [63:0] captured_sb0;

    initial begin
        $display("Starting HDMI Packetizer Verification...");

        // Initialize
        clk = 0;
        rst_n = 0;
        audio_l = 16'h1234;
        audio_r = 16'h5678;
        audio_strobe = 0;
        packet_cnt = 0;
        packet_enable = 0;
        hsync = 0;
        vsync = 0;

        #100 rst_n = 1;
        #100;

        // --- Test 1: ACR Packet (Type 0x01) ---
        // packet_type_sel starts at 0 (ACR)
        $display("--- Verification: ACR Packet (Type 0x01) ---");
        packet_enable = 1;
        captured_header = 0;
        captured_sb0 = 0;

        for (i = 0; i < 32; i = i + 1) begin
            packet_cnt = i;
            @(posedge clk);
            #1; // Wait for combinational logic
            captured_header[i] = island_data[2];
            captured_sb0[i]    = island_data[3];
            captured_sb0[i+32] = island_data[7];
        end

        // Check ACR Header (HB0=0x01, HB1=0, HB2=0)
        // 24'h000001
        if (captured_header[7:0] != 8'h01) begin
            $display("ERROR: Incorrect ACR Packet Type. Expected 0x01, got 0x%h", captured_header[7:0]);
            $finish;
        end
        $display("PASS: ACR Packet Type 0x01 detected.");

        // Check ACR Parameters (CTS=25175, N=6144)
        // PB1=0x06, PB2=0x25, PB3=0x70, PB4=0x01, PB5=0x80, PB6=0x00
        if (captured_sb0[15:8] != 8'h06 || captured_sb0[23:16] != 8'h25 || captured_sb0[31:24] != 8'h70) begin
            $display("ERROR: Incorrect ACR CTS. Got 0x%h%h%h", captured_sb0[15:8], captured_sb0[23:16], captured_sb0[31:24]);
            $finish;
        end
        $display("PASS: ACR CTS (25175) verified.");

        if (captured_sb0[39:32] != 8'h01 || captured_sb0[47:40] != 8'h80 || captured_sb0[55:48] != 8'h00) begin
            $display("ERROR: Incorrect ACR N. Got 0x%h%h%h", captured_sb0[39:32], captured_sb0[47:40], captured_sb0[55:48]);
            $finish;
        end
        $display("PASS: ACR N (6144) verified.");

        packet_enable = 0;
        #200;

        // --- Test 2: Audio Sample Packet (Type 0x02) ---
        // Trigger strobe to load samples
        audio_l = 16'hABCD;
        audio_r = 16'h1234;
        audio_strobe = 1;
        @(posedge clk);
        audio_strobe = 0;

        $display("--- Verification: Audio Sample Packet (Type 0x02) ---");
        // packet_type_sel should have flipped after previous packet_cnt == 31
        packet_enable = 1;
        captured_header = 0;
        captured_sb0 = 0;

        for (i = 0; i < 32; i = i + 1) begin
            packet_cnt = i;
            @(posedge clk);
            #1;
            captured_header[i] = island_data[2];
            captured_sb0[i]    = island_data[3];
            captured_sb0[i+32] = island_data[7];
        end

        // Check Audio Header (HB0=0x02, HB1=0, HB2=0x01)
        if (captured_header[7:0] != 8'h02) begin
            $display("ERROR: Incorrect Audio Packet Type. Expected 0x02, got 0x%h", captured_header[7:0]);
            $finish;
        end
        if (captured_header[23:16] != 8'h01) begin
            $display("ERROR: Incorrect Audio Sample Present bits. Expected 0x01, got 0x%h", captured_header[23:16]);
            $finish;
        end
        $display("PASS: Audio Packet Type 0x02 and Sample Presence (SB0) verified.");

        // Check Audio Samples (L=0xABCD, R=0x1234)
        // SB0 PB1-3: L, PB4-6: R
        if (captured_sb0[15:8] != 8'hCD || captured_sb0[23:16] != 8'hAB) begin
             $display("ERROR: Incorrect Left Audio Sample. Expected 0xABCD, got 0x%h%h", captured_sb0[23:16], captured_sb0[15:8]);
             $finish;
        end
        if (captured_sb0[39:32] != 8'h34 || captured_sb0[47:40] != 8'h12) begin
             $display("ERROR: Incorrect Right Audio Sample. Expected 0x1234, got 0x%h%h", captured_sb0[47:40], captured_sb0[39:32]);
             $finish;
        end
        $display("PASS: Audio samples verified in subpacket 0.");

        $display("\nALL TESTS PASSED SUCCESSFULLY!");
        $finish;
    end

endmodule
