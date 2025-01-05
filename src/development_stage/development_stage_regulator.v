`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module development_stage_regulator (
    input wire [7:0] action,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    output wire inc,
    output wire dec,
    output wire fast,
    output wire setval
);
    /* Actions */
    wire asleep, cry;
    assign asleep = action[0];
    assign cry   = action[7];

    /* Special conditions */
    wire is_ill, starving;
    assign starving  = stimuli[12];
    assign is_ill = stimuli[14];
    
    /* Emotions */
    wire positive_emotions, negative_emotions;
    assign positive_emotions = (emotional_state[0] || emotional_state[1] || emotional_state[6]);
    assign negative_emotions = (emotional_state[2] || emotional_state[3] || emotional_state[4] || emotional_state[7]);

    assign setval = 0;

    /* Regression is possible, but only slowly and for very negative emotions (stressed, apathetic) */
    assign dec = (emotional_state[2] || emotional_state[7]) && !asleep;

    /* Development happens with positive emotions and while healthy  */
    assign inc = (positive_emotions && !is_ill && !starving && !cry);

    /* During the day, development is faster */
    assign fast = (positive_emotions && !is_ill && !starving && !asleep);

endmodule