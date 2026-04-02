/* top.v - m3_uart_echo */
`default_nettype none

module top (
    input  wire clk_27m,      // Pin 45
    output wire uart_tx,      // Pin 18
    input  wire uart_rx,      // Pin 19
    output wire led_pin       // Pin 10
);

    // GPIO
    wire [15:0] m3_gpio_o;
    assign led_pin = m3_gpio_o[0];

    // --- M3 IP Core Instantiation ---
    Gowin_EMPU_M3 m3_inst (
        .SYS_CLK     (clk_27m),
        .UART0RXD    (uart_rx),
        .UART0TXD    (uart_tx),

        // GPIO
        .GPIOO       (m3_gpio_o)
    );

endmodule
