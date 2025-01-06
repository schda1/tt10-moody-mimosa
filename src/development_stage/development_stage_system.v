`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module development_stage_system (
    input wire clk,
    input wire rst_n,
    input wire [15:0] stimuli,
    input wire [7:0] emotional_state,
    input wire [7:0] action,
    output wire [1:0] development_stage
    `ifdef PY_SIM
    , output wire [8:0] dbg_dev_stage_level
    `endif
);
    wire inc, dec, fast, setval;
    wire [8:0] development_stage_level;

    assign development_stage = development_stage_level[8:7];

    development_stage_regulator dev_stage_reg (
        .action(action),
        .emotional_state(emotional_state),
        .stimuli(stimuli),
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval)
    );

    /* energy resource */
    nt_neurotransmitter_level #(
        .N(9),
        .SET_VAL(0),
        .DEFAULT_VAL(0),
        .FAST_STEP(2)
    ) development_stage_lv (
        .clk(clk),
        .rst_n(rst_n),
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval),
        .value(development_stage_level)
    );

    `ifdef PY_SIM
    assign dbg_dev_stage_level = development_stage_level;
    `endif

endmodule