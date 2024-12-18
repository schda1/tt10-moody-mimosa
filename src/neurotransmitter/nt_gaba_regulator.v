`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

/**
 * Background about gaba: 
 * GABA (gamma-aminobutyric acid) is the brain's primary inhibitory neurotransmitter, responsible 
 * for reducing neural excitability and maintaining balance in the nervous system. It promotes 
 * relaxation, reduces stress, and counteracts overactivity caused by excitatory neurotransmitters 
 * like glutamate. GABA plays a key role in regulating sleep, mood, and anxiety. Its calming effects 
 * are crucial for preventing overstimulation and protecting neurons from damage. Imbalances in GABA 
 * levels are associated with conditions like anxiety, insomnia, and epilepsy.
 *
 * Internal, enhancing:
 * - High serotonin, insulin
 * - Low NE and cortisol, glutamate
 * - Feeling tired
 * - During sleep
 *
 * Internal, reducing: 
 * - High cortisol, NE, glutamate
 * - Low serotonin, insulin
 * - Hunger, low energy
 *
 * External, enhancing
 * - Calm down, smile
 * - Quiet, dark
 *
 * External, reducing
 * - Tickling
 * - Loud, bright, hot
 */

module nt_gaba_regulator (
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
    wire cool, hot, loud, dark, bright, quiet;

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
    assign cool = stimuli[5];
    assign hot = stimuli[6];
    assign quiet = stimuli[7];
    assign loud = stimuli[8];
    assign dark = stimuli[9];
    assign bright = stimuli[10];
    assign hungry = stimuli[11];
    assign overfed = stimuli[12];
    assign tired = stimuli[13];

    assign int_enh = (sleep_state == ASLEEP) ||
                     (( tired         ) ||
                      ( SER  == 2'b11 ) ||
                      ( INS  == 2'b11 ) ||
                      ( GLUT == 2'b11 ) ||
                      ( NE   == 2'b00 ) ||
                      ( CORT == 2'b00 )
                     );

    assign int_red = (sleep_state != ASLEEP) &&
                     (( hungry        ) ||
                      ( NE   == 2'b11 ) ||
                      ( NE   == 2'b10 ) ||
                      ( CORT == 2'b11 ) ||
                      ( CORT == 2'b10 ) ||
                      ( SER  == 2'b00 ) ||
                      ( INS  == 2'b00 ) ||
                      ( GLUT == 2'b00 )
                     );

    assign ext_enh = (calm_down || dark || quiet);

    assign ext_red = (tickle || loud || bright || hot);

    // Truth table (reducing dominant)
    assign inc = (!int_red && !ext_red);
    assign dec = (!ext_enh && int_red && !ext_red) || (!int_enh && !int_red && ext_red) || (int_red && ext_red);
    assign fast = (int_red && ext_red) || (int_enh && ext_enh && !int_red && !ext_red);

endmodule