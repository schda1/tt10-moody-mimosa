module au_moody_mimosa (
    input  [7:0] ui_in,    // Input port
    output [7:0] uo_out,   // Output port
    input  [7:0] uio_in,   // Bidirectional port emulation, inputs
    output [7:0] uio_out,  // Bidirectional port emulation, outputs
    output [7:0] led,      // Additional leds
    input  clk,            // Main clock
    input  rst_n,          // Active-low reset
    input  usb_rx,         // UART rx signal
    output usb_tx          // UART tx signal
);

    wire [7:0] ui_in_model;
    wire [7:0] uio_oe; 
    wire ena;      
    wire clk_prescaled;

    // Create model clock, 100 MHz prescaled by 2**26
    static_clock_divider #(.N(26)) model_clk_divider (
        .clk(clk),                  
        .rst_n(rst_n),                
        .clk_out(clk_prescaled)     
    );
    assign ui_in_model = { ui_in[7:1], clk_prescaled};

    // Instantiate the actual moody mimosa module
    moody_mimosa mimosa (
        .ui_in(ui_in_model),              
        .uo_out(uo_out),         
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    assign ena = 1'b1;

endmodule