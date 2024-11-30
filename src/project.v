`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // Always 1 when the design is powered
    input  wire       clk,      // Clock
    input  wire       rst_n     // Active-low reset
);

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, clk, rst_n, 1'b0};

    // Internal signal for the prescaled clock
    wire clk_prescaled;
    
    // Instantiate the prescaler module
    prescaler #(.DIV_FACTOR(4)) prescaler_inst (
        .clk(clk),
        .rst_n(rst_n),
        .clk_out(clk_prescaled)
    );

    // Internal signal for the counter
    wire [3:0] counter;

    // External signal (from ui_in[0]) to trigger counter increment
    wire ext_in_signal = ui_in[0];

    // Instantiate the edge-triggered counter
    edge_triggered_counter counter_inst (
        .clk(clk),  // Use the prescaled clock
        .rst_n(rst_n),
        .ext_in(ext_in_signal),
        .counter(counter)
    );

    // Output assignments
    assign uo_out = {3'b000, counter, clk_prescaled}; // Output counter and prescaled clock
    assign uio_out = 0;                // Unused outputs set to 0
    assign uio_oe  = 0;                // Unused, all set to input (inactive)

endmodule