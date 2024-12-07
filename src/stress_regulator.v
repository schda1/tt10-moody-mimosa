`default_nettype none

module stress_regulator (
    input wire state_controller_inc,
    input wire state_controller_dec,
    input wire [6:0] stimuli,
    output wire stress_inc, 
    output wire stress_dec
);

    // Currently no complex decision
    assign stress_inc = stimuli[0] ? 1'b1 : state_controller_inc;
    assign stress_dec = stimuli[0] ? 1'b0 : state_controller_dec;

endmodule