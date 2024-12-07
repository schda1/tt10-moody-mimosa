`default_nettype none

module energy_regulator (
    input wire state_controller_inc,
    input wire state_controller_dec,
    output wire energy_inc, 
    output wire energy_dec
);

    // Currently no complex decision
    assign energy_inc = state_controller_inc;
    assign energy_dec = state_controller_dec;

endmodule