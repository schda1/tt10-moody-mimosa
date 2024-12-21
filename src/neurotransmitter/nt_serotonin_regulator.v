`default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

/**
 *  Background about serotonin:
 *  Serotonin is a neurotransmitter that plays a key role in mood
 *  regulation, emotional balance, and stress responses. During a
 *  fast stress response, serotonin helps modulate the activity of
 *  stress-related brain circuits, promoting resilience and preventing
 *  overactivation of the stress system. It can counteract excessive anxiety
 *  and support calmness, helping to regulate cortisol release. Low serotonin
 *  levels during stress can lead to heightened anxiety and poor stress coping.
 *  Overall, serotonin acts as a stabilizer in maintaining emotional and physiological
 *  balance during acute stress.
 *
 *  Model:
 *  Contributions are split into internal and external ones, either reducing
 *  or enhancing the neurotransmitter level. Enhancing is considered to be
 *  dominant. If both internal and external factors are present, the effect
 *  is stronger (fast bit set).
 *
 *  Truth table (reducing is dominant)
 *
 *  | Int. enh | Ext. enh | Int red. | Ext. red. | inc | dec | fast |
 *  | x        | 0        | 1        | 0         | 1   | 0   | 0    |
 *  | x        | 0        | 1        | 1         | 0   | 0   | 0    |
 *  | 0        | 1        | 0        | x         | 1   | 0   | 0    |
 *  | 0        | 1        | 0        | 1         | 0   | 0   | 0    |
 *  | x        | x        | 1        | 1         | 1   | 0   | 1    |
 *  | 0        | 0        | 0        | 0         | 0   | 0   | 0    |
 *  | 0        | 0        | 1        | 0         | 0   | 1   | 0    |
 *  | 0        | 0        | 0        | 1         | 0   | 1   | 0    |
 *  | 0        | 0        | 1        | 1         | 0   | 1   | 1    |
 *
 * Internal, enhancing:
 * - Low NE and low cortisol level
 * - High Ach
 * - Low dopamine
 * - High Gaba
 * - During sleep
 *
 * Internal, reducing:
 * - High NE or high cortisol
 * - Low Ach
 * - High Dopamine
 * - Low Gaba
 * - Tired
 * - Hungry
 *
 * External, reducing:
 * - If tired: any interaction
 * - If tired: lout, bright, hot
 *
 * External, enhancing:
 * - Calm down
 */

module nt_serotonin_regulator (
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

    assign int_enh = (sleep) ||
                     (( smile || babble)  ||
                      ( play           )  ||
                      ((SER != 2'b11) && 
                       (( DOP  == 2'b10 ) ||
                        ( DOP  == 2'b11 ) ||
                        ( GABA == 2'b11 ) ||
                        ( NE   == 2'b00 ) ||
                        ( NE   == 2'b01 ) ||
                        ( CORT == 2'b00 ) ||
                        ( CORT == 2'b01 ))
                      )
                     );

    assign int_red = (!sleep) &&
                     (( NE   == 2'b11 )   ||
                      ( CORT == 2'b11 )   ||
                      ((SER != 2'b00) && 
                       (( DOP  == 2'b00    ) ||
                        ( DOP  == 2'b01    ) ||
                        ( GABA == 2'b00    ) ||
                        ( tired || hungry  ) ||
                        ( cry || ill       ) ||
                        ( idle ))
                      )
                     );

    assign ext_enh = (!sleep) && (calm_down);

    assign ext_red = (!sleep) && ((tired || hungry || starving) && (loud || bright || hot));

    // Truth table (reducing dominant)
    assign inc = (!int_red && !ext_red);
    assign dec = (!ext_enh && int_red && !ext_red) || (!int_enh && !int_red && ext_red) || (int_red && ext_red);
    assign fast = (int_red && ext_red) || (int_enh && ext_enh && !int_red && !ext_red);

endmodule