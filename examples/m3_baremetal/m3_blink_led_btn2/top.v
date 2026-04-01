/* top.v - m3_blink_led_btn2 */
`default_nettype none

module top (
    input  wire clk_27m,   // Pin 45
    output wire led_pin,   // Pin 10
    input  wire btn1_pin,  // Pin 15
    input  wire btn2_pin   // Pin 14
);

    // M3 GPIO signals
    wire [15:0] m3_gpio_i;
    wire [15:0] m3_gpio_o;
    wire [15:0] m3_gpio_oe;

    // --- GPIO Mapping ---
    // GPIO[0] is mapped to the LED (Output)
    assign led_pin = m3_gpio_o[0];

    // GPIO[1] and GPIO[2] are mapped to the buttons (Input)
    // Note: buttons are typically active-low on Tang Nano 4K,
    // but we'll assume active-high for simplicity in the C code
    // and let the user handle the physical polarity.
    assign m3_gpio_i[0] = 1'b0;
    assign m3_gpio_i[1] = btn1_pin;
    assign m3_gpio_i[2] = btn2_pin;
    assign m3_gpio_i[15:3] = 13'b0;

    // --- M3 IP Core Instantiation ---
    Gowin_EMPU_M3 m3_inst (
        .GPIOI      (m3_gpio_i),
        .GPIOO      (m3_gpio_o),
        .GPIOOUTEN  (m3_gpio_oe),
        .SYS_CLK    (clk_27m)
    );

endmodule
