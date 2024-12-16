/* verilator lint_off UNUSEDSIGNAL */

`default_nettype none

module nt_cortisol_system (
    input wire clk,
    input wire rst_n,
    input wire [15:0] neurotransmitter_level,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action, 
    input wire [1:0] sleep_state,
    output wire [1:0] cortisol_level
    `ifdef PY_VERILATOR
    , output wire [6:0] dbg_cortisol
    `endif
);

    wire inc, dec, fast, setval;
    wire [6:0] cortisol;

    assign setval = 0;

    /* Regulator for the cortisol level */
    nt_cortisol_regulator cortisol_regulator (
        .neurotransmitter_level(neurotransmitter_level),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .inc(inc),
        .dec(dec), 
        .fast(fast)
    );

    /* cortisol resource */
    nt_neurotransmitter_level #(
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

    `ifdef PY_VERILATOR
    assign dbg_cortisol = cortisol;
    `endif
    
endmodule