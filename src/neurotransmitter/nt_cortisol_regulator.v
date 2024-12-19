`default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

/**
 * Background about cortisol:
 * Cortisol is a steroid hormone produced by the adrenal glands in response
 * to stress, often referred to as the "stress hormone." It plays a key role
 * in regulating metabolism, immune function, and the body's stress response.
 * Cortisol helps increase blood sugar levels, suppress inflammation, and
 * regulate blood pressure during times of stress. However, chronic high levels
 * of cortisol can negatively affect health, leading to issues like anxiety,
 * weight gain, and immune suppression. It also influences various neurotransmitters,
 * impacting mood, cognition, and behavior.
 *
 * Model:
 * In contrast to the fast neurotransmitter regulation, the regulation
 * of the hormone cortisol is slower and consistutes "chronic stress". We assume
 * that it is mainly regulated by the first-level "acute stress" response mediated
 * by norepinephrine NE (also known as noradrenaline). Therefore, it increases
 * when the NE level is high but only decays slowly afterwards. Secondary effects
 * are mediated by the NE regulation, such as e.g. stress induced by hunger, sleep
 * deprivation, extended periods of crying, etc.
 *
 * Internal, enhancing:
 * - High NE
 * - Low gaba
 * - Hunger and tired
 *
 * Internal, reducing:
 * - High Ser
 * - Low NE
 * - Sleep
 *
 * External, enhancing
 * - High NE (double-count)
 * - If tired: talk-to, play-with, tickle
 * - loud and hot
 *
 * External, reducing
 * - If not tired: calm-down, smile
 */

module nt_cortisol_regulator (
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

    assign int_enh = (!is_asleep) &&
                     (( tired && starving ) ||
                      ( ill               ) ||
                      ( NE   == 2'b11     ) ||
                      ( NE   == 2'b10     ) ||
                      ( GABA == 2'b00     )
                     );

    assign int_red = (is_asleep) ||
                     (( SER  == 2'b11 || SER  == 2'b10 ) ||
                      ( GABA == 2'b11 || GABA == 2'b10 ) ||
                      ( NE   == 2'b00 ) ||
                      ( smile || eat  )
                     );

    assign ext_enh = (NE == 2'b11) || 
                     ((!is_asleep) &&
                      ((loud || hot) ||
                       (tired && (talk_to || play_with || tickle)))
                     );

    assign ext_red = (!is_asleep) && (calm_down || talk_to);

    // Truth table
    assign inc = (int_enh && !ext_enh && !ext_red) || (!int_enh && ext_enh && !int_red) || (int_enh && ext_enh);
    assign dec = !int_enh && !ext_enh && (int_red || ext_red);
    assign fast = (int_enh && ext_enh) || (!int_enh && !ext_enh && int_red && ext_red);

endmodule