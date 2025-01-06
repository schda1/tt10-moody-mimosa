`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */
`endif
`default_nettype none

module emotion_regulator (
    input wire [7:0] action,
    input wire [9:0] neurotransmitter_level,
    input wire [15:0] stimuli,
    input wire [1:0] development_stage,
    output wire [7:0] emotional_state
);

    localparam BABY     = 2'b00;
    localparam CHILD    = 2'b01;
    localparam TEENAGER = 2'b10;
    localparam ADULT    = 2'b11;

    wire [1:0] DOP, GABA, SER, CORT, NE;

    /* Neurotransmitter levels */
    assign CORT = neurotransmitter_level[1:0];
    assign DOP  = neurotransmitter_level[3:2];
    assign GABA = neurotransmitter_level[5:4];
    assign NE   = neurotransmitter_level[7:6];
    assign SER  = neurotransmitter_level[9:8];

    /* Asleep */
    wire is_asleep; 
    assign is_asleep = action[0];

    /* Stimuli */
    wire hungry, starving, tired;
    assign hungry    = stimuli[11];
    assign starving  = stimuli[12];
    assign tired     = stimuli[13];

    /* Happy */
    assign emotional_state[0] = (!is_asleep) &&
                                ((NE    == 2'b00 || NE   == 2'b01) && 
                                 (CORT  == 2'b00 || CORT == 2'b01) &&
                                 ((SER  == 2'b10 || SER  == 2'b11) ||
                                  (DOP  == 2'b10 || DOP  == 2'b11) ||
                                  (GABA == 2'b10 || GABA == 2'b11))
                                );

    /* Excited */
    assign emotional_state[1] = (!is_asleep) &&
                                ((NE    == 2'b10 || NE   == 2'b11) &&
                                 (CORT  == 2'b00 || CORT == 2'b01) &&
                                 (DOP   == 2'b10 || DOP  == 2'b11) &&
                                 (GABA  == 2'b00 || GABA == 2'b01)
                                );

    /* Stressed */
    assign emotional_state[2] = (!is_asleep) &&
                                ((NE    == 2'b11) &&
                                 (CORT  != 2'b00) &&
                                 ((SER  == 2'b00 || SER  == 2'b01) ||
                                  (GABA == 2'b00 || GABA == 2'b01) ||
                                  (development_stage == BABY)) &&
                                !(starving && tired)
                                );

    /* Nervous */
    assign emotional_state[3] = (!is_asleep) &&
                                ((NE   == 2'b10) &&
                                 (CORT != 2'b00                  ) &&
                                 ((GABA == 2'b00 || GABA == 2'b01) ||
                                  (SER  == 2'b00 || SER  == 2'b01) ||
                                  (development_stage == BABY))
                                );

    /* Bored */
    assign emotional_state[4] = (!is_asleep) &&
                                ((NE   == 2'b00 || NE   == 2'b01) &&
                                 (CORT == 2'b00 || CORT == 2'b01) &&
                                 ((DOP  == 2'b00 || DOP  == 2'b01) &&
                                  (SER  == 2'b10 || SER  == 2'b11) || (tired))
                                );

    /* Angry */
    assign emotional_state[5] = (!is_asleep) &&
                                ((NE    == 2'b10 || NE   == 2'b11) &&
                                 (DOP   == 2'b00 || DOP  == 2'b01) &&
                                 ((GABA == 2'b00 || GABA == 2'b01) ||
                                  (SER  == 2'b00 || SER  == 2'b01) ||
                                  (development_stage == TEENAGER))
                                );

    /* Calm, amused */
    assign emotional_state[6] = (!is_asleep) &&
                                ((NE    == 2'b00 || NE   == 2'b01) &&
                                 (CORT  == 2'b00 || CORT == 2'b01) &&
                                 (DOP   == 2'b00 || DOP  == 2'b01) &&
                                 ((GABA == 2'b10 || GABA == 2'b11) ||
                                  (SER  == 2'b10 || SER  == 2'b11))
                                );

    /* Apathetic */
    assign emotional_state[7] = (!is_asleep) &&
                                ((CORT  == 2'b11 || CORT  == 2'b10) &&
                                 (SER   == 2'b00) && 
                                 (starving && tired)
                                );

endmodule