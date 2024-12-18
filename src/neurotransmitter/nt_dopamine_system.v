`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module nt_dopamine_system (
    input wire clk, 
    input wire rst_n,
    input wire [15:0] neurotransmitter_level,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action, 
    input wire sleep_state,
    output wire [1:0] dopamine_level 
    `ifdef PY_SIM
    , output wire [6:0] dbg_dopamine
    `endif
);

    wire inc, dec, fast, setval;
    wire [6:0] dopamine;

    assign setval = 0;

    /* Regulator for the dopamine level */
    nt_dopamine_regulator dopamine_regulator (
        .neurotransmitter_level(neurotransmitter_level),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .inc(inc),
        .dec(dec), 
        .fast(fast)
    );

    /* Dopamine resource */
    nt_neurotransmitter_level #(
        .N(7), 
        .SET_VAL(64), 
        .DEFAULT_VAL(64),
        .FAST_STEP(3)
    ) dopamine_resource (
        .clk(clk),
        .rst_n(rst_n), 
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval), 
        .value(dopamine)
    );

    /* Dopamine level, downscaled (2-bit) */
    assign dopamine_level = dopamine[6:5];

    `ifdef PY_SIM
    assign dbg_dopamine = dopamine;
    `endif
    
endmodule