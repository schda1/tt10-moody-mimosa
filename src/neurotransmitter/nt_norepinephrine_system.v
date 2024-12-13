`default_nettype none

module nt_norepinephrine_system (
    input wire clk,                             // Input clock
    input wire rst_n,                           // Active-low reset
    input wire [15:0] neurotransmitter_level,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action, 
    input wire [1:0] sleep_state,
    output wire [1:0] norepinephrine_level      // Updated norepinephrine level
    `ifdef PY_VERILATOR
    , output wire [6:0] dbg_norepinephrine      // Debug output: norepinephrine value
    `endif
);

    wire inc;
    wire dec;
    wire fast;
    wire setval;
    wire [6:0] norepinephrine;

    assign setval = 0;

    /* Regulator for the norepinephrine level */
    nt_norepinephrine_regulator norepinephrine_regulator (
        .neurotransmitter_level(neurotransmitter_level),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .inc(inc),
        .dec(dec), 
        .fast(fast)
    );

    /* norepinephrine resource */
    nt_neurotransmitter_level #(
        .N(7), 
        .SET_VAL(64), 
        .DEFAULT_VAL(96),
        .FAST_STEP(3)
    ) norepinephrine_resource (
        .clk(clk),
        .rst_n(rst_n), 
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval), 
        .value(norepinephrine)
    );

    /* norepinephrine level, downscaled (2-bit) */
    assign norepinephrine_level = norepinephrine[6:5];

    `ifdef PY_VERILATOR
    assign dbg_norepinephrine = norepinephrine;
    `endif
    
endmodule