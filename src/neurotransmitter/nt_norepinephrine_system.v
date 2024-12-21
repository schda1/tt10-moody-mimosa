`default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

module nt_norepinephrine_system (
    input wire clk,                             // Input clock
    input wire rst_n,                           // Active-low reset
    input wire [9:0] neurotransmitter_level,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    output wire [1:0] norepinephrine_level      // Updated norepinephrine level
    `ifdef PY_SIM
    , output wire [6:0] dbg_norepinephrine      // Debug output: norepinephrine value
    `endif
);

    wire inc, dec, fast, setval;
    wire [6:0] norepinephrine;

    assign norepinephrine[6] = 0;
    assign setval = 0;

    /* Regulator for the norepinephrine level */
    nt_norepinephrine_regulator norepinephrine_regulator (
        .neurotransmitter_level(neurotransmitter_level),
        .emotional_state(emotional_state),
        .stimuli(stimuli),
        .action(action),
        .inc(inc),
        .dec(dec),
        .fast(fast)
    );

    /* norepinephrine resource */
    nt_neurotransmitter_level #(
        .N(6),
        .SET_VAL(32),
        .DEFAULT_VAL(0),
        .FAST_STEP(3)
    ) norepinephrine_resource (
        .clk(clk),
        .rst_n(rst_n),
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval),
        .value(norepinephrine[5:0])
    );

    /* norepinephrine level, downscaled (2-bit) */
    assign norepinephrine_level = norepinephrine[5:4];

    `ifdef PY_SIM
    assign dbg_norepinephrine = norepinephrine;
    `endif

endmodule