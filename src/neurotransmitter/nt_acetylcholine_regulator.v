`default_nettype none

/**
 * Background about acetylcholine: 
 * Acetylcholine (ACh) is a neurotransmitter that plays a key role in both the central and peripheral 
 * nervous systems. In the brain, it is involved in attention, learning, memory, and the regulation of 
 * sleep-wake cycles. In the peripheral nervous system, ACh is essential for muscle contraction, as it 
 * activates the muscles through the neuromuscular junction. It also helps modulate the autonomic nervous 
 * system, influencing heart rate and digestion. Overall, ACh is critical for cognitive function, motor 
 * control, and maintaining bodily homeostasis.
 * 
 * Internal, enhancing:
 * - High glutamate, dopamine
 * - Low cortisol, gaba
 * - tired or hungry
 *
 * Internal, reducing: 
 * - High serotonin, insulin, cortisol, NE
 * - Tired
 * - Sleep
 *
 * External, enhancing
 * - Talking to, playing with
 * - Bright
 * - Calming down
 * - Physical exercise
 *
 * External, reducing
 * - Loud, hot
 */

module nt_acetylcholine_regulator (
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

assign int_enh = (sleep_state != ASLEEP) &&
                 (( hungry        ) ||
                  ( GLUT == 2'b11 ) ||
                  ( DOP  == 2'b11 ) ||
                  ( CORT == 2'b00 ) ||
                  ( GABA == 2'b00 )
                 );

assign int_red = (sleep_state == ASLEEP) ||
                 (( tired       ) ||
                  ( SER  == 2'b11 ) ||
                  ( INS  == 2'b11 ) ||
                  ( CORT == 2'b11 ) ||
                  ( NE   == 2'b11 ) ||
                  ( INS  == 2'b11 )
                 );

assign ext_enh = (sleep_state != ASLEEP) &&
                 (talk_to || play_with || calm_down || bright);

assign ext_red = (sleep_state != ASLEEP) &&
                 (loud || hot);

// Truth table
assign inc = (int_enh && !ext_enh && !ext_red) || (!int_enh && ext_enh && !int_red) || (int_enh && ext_enh);
assign dec = !int_enh && !ext_enh && (int_red || ext_red);
assign fast = (int_enh && ext_enh) || (!int_enh && !ext_enh && int_red && ext_red);

endmodule