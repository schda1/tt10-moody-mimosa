`default_nettype none

module energy_regulator (
    input wire sleep_controller_inc,
    input wire sleep_controller_dec,
    output wire energy_inc, 
    output wire energy_dec
);

    // Currently no complex decision
    assign energy_inc = sleep_controller_inc;
    assign energy_dec = sleep_controller_dec;

endmodule