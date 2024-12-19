`default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

/**
 *  Background about norepinephrine:
 *  Norepinephrine (NE) is a neurotransmitter and hormone involved in the body's
 *  fast stress response, often referred to as the "fight or flight" reaction.
 *  It is released by the adrenal glands and nerve endings in response to stress
 *  or danger. NE increases heart rate, blood pressure, and blood flow to muscles,
 *  preparing the body for rapid action. It also enhances alertness and focus, helping
 *  the brain respond quickly to threats. In chronic stress, sustained high levels of
 *  norepinephrine can contribute to anxiety and other stress-related disorders.
 *
 *  Model:
 *  This regulator could become arbitrary complex as there are so many different
 *  internal and external effects influencing the NE level. To make the model
 *  reasonably simple, we distinguish between internal and external effects, both
 *  for the enhancing and reducing channel.
 *
 *  High-level truth table:
 *
 *  | Int. enh | Ext. enh | Int red. | Ext. red. | inc | dec | fast |
 *  | 1        | 0        | x        | 0         | 1   | 0   | 0    |
 *  | 1        | 0        | x        | 1         | 0   | 0   | 0    |
 *  | 0        | 1        | 0        | x         | 1   | 0   | 0    |
 *  | 0        | 1        | 0        | 1         | 0   | 0   | 0    |
 *  | 1        | 1        | x        | x         | 1   | 0   | 1    |
 *  | 0        | 0        | 0        | 0         | 0   | 0   | 0    |
 *  | 0        | 0        | 1        | 0         | 0   | 1   | 0    |
 *  | 0        | 0        | 0        | 1         | 0   | 1   | 0    |
 *  | 0        | 0        | 1        | 1         | 0   | 1   | 1    |
 *
 *  Internal enhancing:
 *  - Hungry
 *  - Tired
 *  - Low levels of gaba
 *  - Insulin LOW or HIGH
 *  - High levels of dopamine
 *  - High levels of ACH or glutamate
 *
 *  External enhancing:
 *  - If tired: any interaction
 *  - If tired: noise
 *  - If tired: bright light
 *  - Warm / cold, always
 *
 *  Internal reducing:
 *  - State: ASLEEP
 *  - High levels of gaba
 *  - Insulin not LOW or HIGH
 *  - High levels of serotonin
 *
 *  External reducing:
 *  - Calming
 *  - Smiling
 */

module nt_norepinephrine_regulator (
    input wire [9:0] neurotransmitter_level,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    output wire inc,
    output wire dec,
    output wire fast
);

    wire int_enh, ext_enh, int_red, ext_red;

    /* Neurotransmitter levels */
    wire [1:0] DOP, GABA, SER, CORT, NE;
    assign CORT = neurotransmitter_level[1:0];
    assign DOP  = neurotransmitter_level[3:2];
    assign GABA = neurotransmitter_level[5:4];
    assign NE   = neurotransmitter_level[7:6];
    assign SER  = neurotransmitter_level[9:8];

    /* Actions */
    wire sleep, eat, play, smile, babble, kick_legs, idle, cry;
    assign sleep     = action[0];
    assign eat       = action[1];
    assign play      = action[2];
    assign smile     = action[3];
    assign babble    = action[4];
    assign kick_legs = action[5];
    assign idle      = action[6];
    assign cry       = action[7];

    /* Asleep */
    wire is_asleep; 
    assign is_asleep = action[0];

    /* Stimuli */
    wire hungry, starving, tired, ill;
    wire tickle, play_with, talk_to, calm_down;
    wire cool, hot, loud, dark, bright, quiet;
    assign tickle    = stimuli[0];
    assign play_with = stimuli[1];
    assign talk_to   = stimuli[2];
    assign calm_down = stimuli[3];
    assign cool      = stimuli[5];
    assign hot       = stimuli[6];
    assign quiet     = stimuli[7];
    assign loud      = stimuli[8];
    assign dark      = stimuli[9];
    assign bright    = stimuli[10];
    assign hungry    = stimuli[11];
    assign starving  = stimuli[12];
    assign tired     = stimuli[13];
    assign ill       = stimuli[14];

    

    assign int_enh =  (hungry) ||
                      ((!is_asleep         ) &&
                       (( hungry || tired  ) ||
                        ( ill              ) ||
                        ( cry || kick_legs ) ||
                        ( GABA == 2'b00    ) ||
                        ( DOP  == 2'b11    )
                       ));

    assign int_red = (is_asleep) ||
                     (( GABA == 2'b11 || GABA == 2'b10)  ||
                      ( SER  == 2'b11 || SER  == 2'b10)  ||
                      ( eat || smile || babble || play)
                     );

    assign ext_enh = (((is_asleep) &&
                       ( tickle || play_with || talk_to || calm_down || hot || loud || bright)) ||
                      ((!is_asleep) && ( tired || hungry || starving ) &&
                       (tickle || play_with || talk_to || loud || bright)) ||
                      (hot)
                    );

    assign ext_red = (is_asleep) || ((!is_asleep) && (calm_down || talk_to));

    // Truth table
    // assign inc = (int_enh && !ext_enh && !ext_red) || (!int_enh && ext_enh && !int_red) || (int_enh && ext_enh);
    // assign dec = !int_enh && !ext_enh && (int_red || ext_red);
    // assign fast = (int_enh && ext_enh) || (!int_enh && !ext_enh && int_red && ext_red);

    assign inc = (!int_red && !ext_red);
    assign dec = (!ext_enh && int_red && !ext_red) || (!int_enh && !int_red && ext_red) || (int_red && ext_red);
    assign fast = (int_red && ext_red) || (int_enh && ext_enh && !int_red && !ext_red);


endmodule