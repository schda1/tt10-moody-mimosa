`default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

module nt_neurotransmitter_system (
    input wire clk,
    input wire rst_n,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    input wire [9:0] neurotransmitter_level_in,
    output wire [9:0] neurotransmitter_level_out
    `ifdef PY_SIM
    , output wire [6:0] dbg_cortisol
    , output wire [6:0] dbg_dopamine
    , output wire [6:0] dbg_gaba
    , output wire [6:0] dbg_norepinephrine
    , output wire [6:0] dbg_serotonin
    `endif
);

    wire [1:0] cortisol_level;
    wire [1:0] dopamine_level;
    wire [1:0] gaba_level;
    wire [1:0] norepinephrine_level;
    wire [1:0] serotonin_level;

    nt_cortisol_system cortisol_system (
        .clk(clk),
        .rst_n(rst_n),
        .neurotransmitter_level(neurotransmitter_level_in),
        .emotional_state(emotional_state),
        .stimuli(stimuli),
        .action(action),
        .cortisol_level(cortisol_level)
        `ifdef PY_SIM
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
        .dopamine_level(dopamine_level)
        `ifdef PY_SIM
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
        .gaba_level(gaba_level)
        `ifdef PY_SIM
        , .dbg_gaba(dbg_gaba)
        `endif
    );

    nt_norepinephrine_system norepinephrine_system (
        .clk(clk),
        .rst_n(rst_n),
        .neurotransmitter_level(neurotransmitter_level_in),
        .emotional_state(emotional_state),
        .stimuli(stimuli),
        .action(action),
        .norepinephrine_level(norepinephrine_level)
        `ifdef PY_SIM
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
        .serotonin_level(serotonin_level)
        `ifdef PY_SIM
        , .dbg_serotonin(dbg_serotonin)
        `endif
    );

    assign neurotransmitter_level_out[1:0] = cortisol_level;
    assign neurotransmitter_level_out[3:2] = dopamine_level;
    assign neurotransmitter_level_out[5:4] = gaba_level;
    assign neurotransmitter_level_out[7:6] = norepinephrine_level;
    assign neurotransmitter_level_out[9:8] = serotonin_level;

endmodule