`default_nettype none

module pleasure_regulator (
    input wire sleep_controller_inc,
    input wire sleep_controller_dec,
    input wire [6:0] stimuli,
    output wire pleasure_inc, 
    output wire pleasure_dec
);

    // Currently no complex decision
    assign pleasure_inc = stimuli[1] ? 1'b1 : sleep_controller_inc;
    assign pleasure_dec = stimuli[0] ? 1'b1 : sleep_controller_dec;

endmodule