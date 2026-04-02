module top (
    input  wire clk_27m,  // Pin 45
    inout wire [15:0] m3_gpio,
    // output wire led_pin,   // Pin 10
    // input  wire btn1_pin,  // Pin 15
    input wire btn2_pin   // Pin 14
);
    // --- M3 IP Core Instantiation ---
    Gowin_EMPU_Top m3_inst (
		.sys_clk(clk_27m), //input sys_clk
		.gpio(m3_gpio),    //inout [15:0] gpio
		.reset_n(btn2_pin) //input reset_n
    );

endmodule
