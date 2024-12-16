/* verilator lint_off UNUSEDSIGNAL */
`default_nettype none

/**
 * Background about insuline: 
 * Insulin is a hormone produced by the pancreas, primarily responsible for regulating 
 * blood glucose levels. It facilitates the uptake of glucose into cells for energy 
 * production and storage. Insulin also plays a role in fat storage and protein synthesis. 
 * While not typically classified as a neurotransmitter, insulin affects brain function by 
 * influencing energy availability and metabolism in neurons. Imbalances in insulin levels 
 * can impact mood, cognition, and stress responses, particularly in relation to blood sugar 
 * levels.
 * 
 * Internal, enhancing:
 * - High ACH
 * - Overfed
 * - Feed (double count)
 *
 * Internal, reducing: 
 * - Low GABA or ACH
 * - High Cortisol
 * - Hunger
 * - Sleep
 *
 * External, enhancing
 * - Feed
 *
 * External, reducing
 * - Play_with
 */

module nt_insulin_regulator (
    input wire [15:0] neurotransmitter_level,   
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action, 
    input wire [1:0] sleep_state,
    output wire inc,
    output wire dec,
    output wire fast
);

    localparam ASLEEP = 2'b00;  
    wire int_enh, ext_enh, int_red, ext_red;

    wire [1:0] ACH, DOP, GABA, GLUT, INS, SER, CORT, NE;
    wire stessed, hungry, overfed, tired;
    wire feed, tickle, play_with, talk_to, calm_down;
    wire cool, hot, loud, dark, bright;

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
    assign feed = stimuli[4];
    assign cool = stimuli[5];
    assign hot = stimuli[6];
    assign loud = stimuli[8];
    assign dark = stimuli[9];
    assign bright = stimuli[10];
    assign hungry = stimuli[11];
    assign overfed = stimuli[12];
    assign tired = stimuli[13];

    assign int_enh = (sleep_state != ASLEEP) && 
                     (( overfed       ) ||
                      ( ACH  == 2'b11 ) ||
                      ( feed          )
                     );

    assign int_red = (sleep_state == ASLEEP) ||
                     ( hungry        )  ||
                     ( CORT == 2'b11 )  ||
                     ( GABA == 2'b00 )  ||
                     ( ACH  == 2'b00 );

    assign ext_enh = (sleep_state != ASLEEP) && (feed);

    assign ext_red = (sleep_state != ASLEEP) && (~tired) && (play_with);

    // Truth table (reducing dominant)
    assign inc = (!int_red && !ext_red);
    assign dec = (!ext_enh && int_red && !ext_red) || (!int_enh && !int_red && ext_red) || (int_red && ext_red);
    assign fast = (int_red && ext_red) || (int_enh && ext_enh && !int_red && !ext_red);

endmodule