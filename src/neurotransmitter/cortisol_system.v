`default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

module cortisol_system (
    input wire clk,
    input wire rst_n,
    input wire [9:0] neurotransmitter_level,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    output wire [1:0] cortisol_level
    `ifdef PY_SIM
    , output wire [6:0] dbg_cortisol
    `endif
);

    wire inc, dec, fast, setval;
    wire [6:0] cortisol;

    assign setval = 0;

    /* Regulator for the cortisol level */
    cortisol_regulator cortisol_regulator (
        .neurotransmitter_level(neurotransmitter_level),
        .emotional_state(emotional_state),
        .stimuli(stimuli),
        .action(action),
        .inc(inc),
        .dec(dec),
        .fast(fast)
    );

    /* cortisol resource */
    resource #(
        .N(7),
        .SET_VAL(64),
        .DEFAULT_VAL(0),
        .FAST_STEP(2)
    ) cortisol_resource (
        .clk(clk),
        .rst_n(rst_n),
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval),
        .value(cortisol)
    );

    /* cortisol level, downscaled (2-bit) */
    assign cortisol_level = cortisol[6:5];

    `ifdef PY_SIM
    assign dbg_cortisol = cortisol;
    `endif

endmodule