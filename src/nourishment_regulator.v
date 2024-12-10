`default_nettype none

module nourishment_regulator (
    input wire state_controller_inc,
    input wire state_controller_dec,
    output wire nourishment_inc, 
    output wire nourishment_dec
);

    // Currently no complex decision
    assign nourishment_inc = 0;
    assign nourishment_dec = 0;

endmodule