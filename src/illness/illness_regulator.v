`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module illness_regulator (
    input wire [9:0] neurotransmitter_level,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    input wire [1:0] illness_level,
    output wire inc,
    output wire dec,
    output wire fast,
    output wire setval
);

     /* Neurotransmitter levels */
    wire [1:0] CORT;
    assign CORT = neurotransmitter_level[1:0];

    /* Actions */
    wire sleep, eat, play, smile, babble, kick_legs, idle, cry;
    assign sleep     = action[0];
    assign cry       = action[7];

    /* Stimuli */
    wire cool, starving, tired;
    assign cool      = stimuli[5];
    assign starving  = stimuli[12];
    assign tired     = stimuli[13];

    /* Ill state */
    wire is_ill;
    assign is_ill = stimuli[14];

    assign setval = 0;
    assign inc = !is_ill;
    assign dec = is_ill;
    assign fast = (!sleep) &&
                  ((is_ill &&
                    (CORT == 2'b00 || CORT == 2'b01)  &&
                    (!starving && !tired && !cry   )) ||
                   (!is_ill && 
                    ((CORT == 2'b10 || CORT == 2'b11) ||
                     (starving || tired || cry      )
                    )
                   )
                  );

endmodule