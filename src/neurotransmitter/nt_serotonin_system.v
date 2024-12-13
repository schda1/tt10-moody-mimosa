`default_nettype none

module nt_serotonin_system (
    input wire clk,
    input wire rst_n,
    input wire [15:0] neurotransmitter_level,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action, 
    input wire [1:0] sleep_state,
    output wire [1:0] serotonin_level
    `ifdef PY_VERILATOR
    , output wire [6:0] dbg_serotonin
    `endif
);

    wire inc;
    wire dec;
    wire fast;
    wire setval;
    wire [6:0] serotonin;

    assign setval = 0;

    /* Regulator for the serotonin level */
    nt_serotonin_regulator serotonin_regulator (
         .neurotransmitter_level(neurotransmitter_level),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .inc(inc),
        .dec(dec), 
        .fast(fast)
    );

    /* serotonin resource */
    nt_neurotransmitter_level #(
        .N(7), 
        .SET_VAL(64), 
        .DEFAULT_VAL(96),
        .FAST_STEP(3)
    ) serotonin_resource (
        .clk(clk),
        .rst_n(rst_n), 
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval), 
        .value(serotonin)
    );

    /* serotonin level, downscaled (2-bit) */
    assign serotonin_level = serotonin[6:5];

    `ifdef PY_VERILATOR
    assign dbg_serotonin = serotonin;
    `endif
    
endmodule