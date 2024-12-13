`default_nettype none

module nt_neurotransmitter_system (
    input wire clk,
    input wire rst_n,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    input wire [1:0] sleep_state,
    input wire [15:0] neurotransmitter_level_in,
    output wire [15:0] neurotransmitter_level_out
    `ifdef PY_VERILATOR
    , output wire [6:0] dbg_acetylcholine      
    , output wire [6:0] dbg_cortisol
    , output wire [6:0] dbg_dopamine
    , output wire [6:0] dbg_gaba
    , output wire [6:0] dbg_glutamate
    , output wire [6:0] dbg_insulin
    , output wire [6:0] dbg_norepinephrine
    , output wire [6:0] dbg_serotonin
    `endif
);

    wire [1:0] acetylcholine_level;
    wire [1:0] cortisol_level;
    wire [1:0] dopamine_level;
    wire [1:0] gaba_level;
    wire [1:0] glutamate_level;
    wire [1:0] insulin_level;
    wire [1:0] norepinephrine_level;
    wire [1:0] serotonin_level;

    nt_acetylcholine_system acetylcholin_system (
        .clk(clk),
        .rst_n(rst_n),
        .neurotransmitter_level(neurotransmitter_level_in),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state), 
        .acetylcholine_level(acetylcholine_level)
        `ifdef PY_VERILATOR
        , .dbg_acetylcholin(dbg_acetylcholin)
        `endif
    );

    nt_cortisol_system cortisol_system (
        .clk(clk),
        .rst_n(rst_n),
        .neurotransmitter_level(neurotransmitter_level_in),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state), 
        .cortisol_level(cortisol_level)
        `ifdef PY_VERILATOR
        , .dbg_cortisol(dbg_cortisol)
        `endif
    );

    nt_dopamine_system dopamine_system (
        .clk(clk),
        .rst_n(rst_n),
        .neurotransmitter_level(neurotransmitter_level_in),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state), 
        .dopamine_level(dopamine_level)
        `ifdef PY_VERILATOR
        , .dbg_dopamine(dbg_dopamine)
        `endif
    );

    nt_gaba_system gaba_system (
        .clk(clk),
        .rst_n(rst_n),
        .neurotransmitter_level(neurotransmitter_level_in),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .gaba_level(gaba_level)
        `ifdef PY_VERILATOR
        , .dbg_gaba(dbg_gaba)
        `endif
    );

    nt_glutamate_system glutamate_system (
        .clk(clk),
        .rst_n(rst_n),
        .neurotransmitter_level(neurotransmitter_level_in),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .glutamate_level(glutamate_level)
        `ifdef PY_VERILATOR
        , .dbg_glutamate(dbg_glutamate)
        `endif
    );

    nt_insulin_system insulin_system (
        .clk(clk),
        .rst_n(rst_n),
        .neurotransmitter_level(neurotransmitter_level_in),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .insulin_level(insulin_level)
        `ifdef PY_VERILATOR
        , .dbg_insulin(dbg_insulin)
        `endif
    );

    nt_norepinephrine_system norepinephrine_system (
        .clk(clk),
        .rst_n(rst_n),
        .neurotransmitter_level(neurotransmitter_level_in),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .norepinephrine_level(norepinephrine_level)
        `ifdef PY_VERILATOR
        , .dbg_norepinephrine(dbg_norepinephrine)
        `endif
    );

    nt_serotonin_system serotonin_system (
        .clk(clk),
        .rst_n(rst_n),
        .neurotransmitter_level(neurotransmitter_level_in),
        .emotional_state(emotional_state),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .serotonin_level(serotonin_level)
        `ifdef PY_VERILATOR
        , .dbg_serotonin(dbg_serotonin)
        `endif
    );

    assign neurotransmitter_level_out[1:0] = acetylcholine_level;
    assign neurotransmitter_level_out[3:2] = cortisol_level;
    assign neurotransmitter_level_out[5:4] = dopamine_level;
    assign neurotransmitter_level_out[7:6] = gaba_level;
    assign neurotransmitter_level_out[9:8] = glutamate_level;
    assign neurotransmitter_level_out[11:10] = insulin_level;
    assign neurotransmitter_level_out[13:12] = norepinephrine_level;
    assign neurotransmitter_level_out[15:14] = serotonin_level;

endmodule
