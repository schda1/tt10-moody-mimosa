`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module nt_glutamate_system (
    input wire clk,
    input wire rst_n,
    input wire [15:0] neurotransmitter_level,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action, 
    input wire sleep_state,
    output wire [1:0] glutamate_level
    `ifdef PY_SIM
    , output wire [6:0] dbg_glutamate
    `endif
);

    wire inc, dec, fast, setval;
    wire [6:0] glutamate;

    assign setval = 0;

    /* Regulator for the glutamate level */
    nt_glutamate_regulator glutamate_regulator (
        .neurotransmitter_level(neurotransmitter_level),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .inc(inc),
        .dec(dec), 
        .fast(fast)
    );

    /* glutamate resource */
    nt_neurotransmitter_level #(
        .N(7), 
        .SET_VAL(64), 
        .DEFAULT_VAL(32),
        .FAST_STEP(3)
    ) glutamate_resource (
        .clk(clk),
        .rst_n(rst_n), 
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval), 
        .value(glutamate)
    );

    /* glutamate level, downscaled (2-bit) */
    assign glutamate_level = glutamate[6:5];

    `ifdef PY_SIM
    assign dbg_glutamate = glutamate;
    `endif
    
endmodule