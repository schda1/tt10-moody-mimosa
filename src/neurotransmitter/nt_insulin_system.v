`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module nt_insulin_system (
    input wire clk,
    input wire rst_n,
    input wire [15:0] neurotransmitter_level,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action, 
    input wire sleep_state,
    output wire [1:0] insulin_level
    `ifdef PY_SIM
    , output wire [6:0] dbg_insulin
    `endif  
);

    wire inc, dec, fast, setval;
    wire [6:0] insulin;

    assign setval = 0;

    /* Regulator for the insulin level */
    nt_insulin_regulator insulin_regulator (
        .neurotransmitter_level(neurotransmitter_level),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .inc(inc),
        .dec(dec), 
        .fast(fast)
    );

    /* insulin resource */
    nt_neurotransmitter_level #(
        .N(7), 
        .SET_VAL(64), 
        .DEFAULT_VAL(64),
        .FAST_STEP(3)
    ) insulin_resource (
        .clk(clk),
        .rst_n(rst_n), 
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval), 
        .value(insulin)
    );

    /* insulin level, downscaled (2-bit) */
    assign insulin_level = insulin[6:5];

    `ifdef PY_SIM
    assign dbg_insulin = insulin;
    `endif

endmodule