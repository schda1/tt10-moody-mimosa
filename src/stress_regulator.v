`default_nettype none

module stress_regulator (
    input wire sleep_controller_inc,
    input wire sleep_controller_dec,
    input wire [6:0] stimuli,
    output wire stress_inc, 
    output wire stress_dec
);

    // Currently no complex decision
    assign stress_inc = stimuli[0] ? 1'b1 : sleep_controller_inc;
    assign stress_dec = stimuli[0] ? 1'b0 : sleep_controller_dec;

endmodule