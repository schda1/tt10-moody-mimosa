`default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

/**
 * Background about dopamine:
 * Dopamine is a neurotransmitter that plays a central role in reward,
 * motivation, and pleasure. It regulates mood, attention, learning, and
 * motor control. High dopamine levels are associated with feelings of euphoria
 * and drive, while low levels can lead to apathy, depression, or motor impairments.
 * Dopamine also influences the brain's stress response by modulating other
 * neurotransmitters like serotonin and GABA. Its balance is critical for emotional
 * well-being, decision-making, and physical coordination.
 *
 * Internal, enhancing:
 * - Low Cortisol, NE, gaba, insulin
 * - Tired
 * - Hunger
 *
 * Internal, reducing:
 * - High cortisol, NE, serotonin, gaba, insulin
 * - Overfeeding
 * - Sleep
 *
 * External, enhancing
 * - if not tired: talk-to, play
 * - bright light
 * - cool
 *
 * External, reducing
 * - loud, hot
 * - if tired: bright
 * - if tired: talk-to, play
 */

module nt_dopamine_regulator (
    input wire [9:0] neurotransmitter_level,
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    input wire [1:0] development_stage,
    output wire inc,
    output wire dec,
    output wire fast
);

    localparam BABY     = 2'b00;
    localparam CHILD    = 2'b01;
    localparam TEENAGER = 2'b10;
    localparam ADULT    = 2'b11;

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
                     (( tired || hungry ) ||
                      ( play | kick_legs) ||
                      ( CORT == 2'b00   ) ||
                      ( CORT == 2'b01   ) ||
                      ( NE   == 2'b00   ) ||
                      ( NE   == 2'b01   ) ||
                      ((DOP != 2'b11) && 
                       (( GABA == 2'b11   ) ||
                        ( GABA == 2'b10   ) || 
                        ( SER  == 2'b11   ))
                      ) 
                     );

    assign int_red = (is_asleep) ||
                     (( starving        )    ||
                      ( tired && hungry )    ||
                      ( CORT == 2'b11   )    ||
                      ( NE   == 2'b11   )    ||
                      ((DOP != 2'b00) && 
                       (( SER  == 2'b00   )  ||
                        ( GABA == 2'b00   )  ||
                        ( cry || idle     ))
                      )
                     );

    assign ext_enh = (!is_asleep) &&
                     ((bright || cool) || 
                      ((~tired) && (talk_to || play_with)));

    assign ext_red = (!is_asleep) &&
                     ((loud || hot) || 
                      ((~tired) && (bright || talk_to || play_with)));

    // Truth table (reducing dominant)
    assign inc = (!int_red && !ext_red) && (CORT != 2'b11);
    assign dec = (!ext_enh && int_red && !ext_red) || (!int_enh && !int_red && ext_red) || (int_red && ext_red) || (CORT == 2'b11);
    assign fast = (int_red && ext_red) || (int_enh && ext_enh && !int_red && !ext_red) || (development_stage == TEENAGER);

endmodule