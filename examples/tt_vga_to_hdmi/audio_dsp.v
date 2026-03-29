/*
 * audio_dsp.v: 2nd Order CIC Filter for 1-bit to PCM conversion.
 *
 * Decimation Ratio (R) = 525.
 * Input: 1-bit PWM/PDM @ 25.175 MHz.
 * Output: 16-bit signed PCM @ 47.952 kHz.
 */

`default_nettype none

module audio_dsp (
    input  wire        clk,        // Pixel clock (25.175 MHz)
    input  wire        rst_n,      // Reset (active low)
    input  wire        audio_bit,  // 1-bit audio input
    output reg  [15:0] pcm_out,    // 16-bit signed PCM output
    output reg         strobe_48k  // Pulse every R cycles
);

    // Decimation ratio R=525
    reg [9:0] count;

    // Integrator stages
    // Max value after R cycles is approx R*(R+1)/2 = 138075.
    // 18 bits required (2^17 = 131072, 2^18 = 262144).
    // Use 20 bits to be safe and handle wrapping differentiation.
    reg [19:0] int1;
    reg [19:0] int2;

    // Comb stages (running at decimated rate)
    reg [19:0] int2_d1;
    reg [19:0] comb1;
    reg [19:0] comb1_d1;
    reg [19:0] comb2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            int1 <= 0;
            int2 <= 0;
            int2_d1 <= 0;
            comb1 <= 0;
            comb1_d1 <= 0;
            comb2 <= 0;
            pcm_out <= 0;
            strobe_48k <= 0;
        end else begin
            // Integrators run at high speed (pixel clock)
            int1 <= int1 + audio_bit;
            int2 <= int2 + int1;

            if (count == 524) begin
                count <= 0;
                strobe_48k <= 1'b1;

                // Comb stages
                comb1 <= int2 - int2_d1;
                int2_d1 <= int2;

                comb2 <= comb1 - comb1_d1;
                comb1_d1 <= comb1;

                // Normalization:
                // comb2 range is [0, 138075].
                // Center is ~69037.
                // Scale down by 4 to fit in 16-bit signed range.
                // 138075 / 4 = 34518.
                // Offset = 69037 / 4 = 17259.
                pcm_out <= comb2[17:2] - 16'd17259;
            end else begin
                count <= count + 1;
                strobe_48k <= 1'b0;
            end
        end
    end

endmodule
