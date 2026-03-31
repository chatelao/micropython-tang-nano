/*
 * FPGA Wrapper for Adaptive Blink on Tang Nano 4K
 * Connects M3 GPIOs to physical LED and Buttons.
 */

`default_nettype none

module blink_wrapper (
    input  wire clk_27m,
    output wire led_pin,   // Physical Pin 10
    input  wire btn1_pin,  // Physical Pin 15
    input  wire btn2_pin   // Physical Pin 14
);

    // M3 GPIO signals (standard naming for Gowin_EMPU_M3)
    wire [15:0] m3_gpio_i;
    wire [15:0] m3_gpio_o;
    wire [15:0] m3_gpio_oe;

    // --- GPIO Mapping ---
    // GPIO[0] is mapped to the LED (Output)
    assign led_pin = m3_gpio_o[0];

    // GPIO[1] and GPIO[2] are mapped to the buttons (Input)
    assign m3_gpio_i[0] = 1'b0;
    assign m3_gpio_i[1] = btn1_pin;
    assign m3_gpio_i[2] = btn2_pin;
    assign m3_gpio_i[15:3] = 13'b0;

    // --- M3 IP Core Instantiation ---
    // This instantiates the Cortex-M3 hard core.
    EMCU m3_inst (
        .GPIOI      (m3_gpio_i),
        .GPIOO      (m3_gpio_o),
        .GPIOOUTEN  (m3_gpio_oe),
        .SYS_CLK    (clk_27m)
    );

endmodule
