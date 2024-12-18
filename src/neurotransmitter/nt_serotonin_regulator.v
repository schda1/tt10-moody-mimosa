`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

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
    input wire [15:0] neurotransmitter_level,   
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action, 
    input wire sleep_state,
    output wire inc,
    output wire dec,
    output wire fast
);

    localparam ASLEEP = 1'b0;  
    wire int_enh, ext_enh, int_red, ext_red;

    wire [1:0] ACH, DOP, GABA, GLUT, INS, SER, CORT, NE;
    wire stessed, hungry, overfed, tired;
    wire tickle, play_with, talk_to, calm_down;
    wire hot, loud, bright;

    /* Neurotransmitter levels */
    assign ACH  = neurotransmitter_level[1:0];
    assign CORT = neurotransmitter_level[3:2];
    assign DOP  = neurotransmitter_level[5:4];
    assign GABA = neurotransmitter_level[7:6];
    assign GLUT = neurotransmitter_level[9:8];
    assign INS  = neurotransmitter_level[11:10];
    assign NE   = neurotransmitter_level[13:12];
    assign SER  = neurotransmitter_level[15:14];

    /* Emotional states */ 
    assign stessed = emotional_state[1];

    /* Stimuli */
    assign tickle = stimuli[0];
    assign play_with = stimuli[1];
    assign talk_to = stimuli[2];
    assign calm_down = stimuli[3];
    assign hot = stimuli[6];
    assign loud = stimuli[8];
    assign bright = stimuli[10];
    assign hungry = stimuli[11];
    assign overfed = stimuli[12];
    assign tired = stimuli[13];

    assign int_enh = (sleep_state == ASLEEP) || 
                     (( hungry        ) ||
                      ( tired         ) ||
                      ( ACH  == 2'b11 ) ||
                      ( DOP  == 2'b00 ) ||
                      ( GABA == 2'b11 ) ||
                      ( NE   == 2'b00 ) ||
                      ( NE   == 2'b01 ) ||
                      ( CORT == 2'b00 ) ||
                      ( CORT == 2'b01 )
                     );

    assign int_red = (sleep_state != ASLEEP) && 
                     (( NE   == 2'b11 )  ||
                      ( CORT == 2'b11 )  ||
                      ( ACH  == 2'b00 )  ||
                      ( DOP  == 2'b11 )  ||
                      ( GABA == 2'b00 )  ||
                      ( tired         )  ||
                      ( hungry        )
                     );

    assign ext_enh = (sleep_state != ASLEEP) && (calm_down);

    assign ext_red = (sleep_state != ASLEEP) &&  ((tired || hungry) && (loud || bright || hot));

    // Truth table (reducing dominant)
    assign inc = (!int_red && !ext_red);
    assign dec = (!ext_enh && int_red && !ext_red) || (!int_enh && !int_red && ext_red) || (int_red && ext_red);
    assign fast = (int_red && ext_red) || (int_enh && ext_enh && !int_red && !ext_red);

endmodule
