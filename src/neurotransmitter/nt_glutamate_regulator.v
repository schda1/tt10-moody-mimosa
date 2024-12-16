/* verilator lint_off UNUSEDSIGNAL */
`default_nettype none

/** 
 * Background about glutamate: 
 * Glutamate is the brain's primary excitatory neurotransmitter, essential for 
 * learning, memory, and overall neural communication. It facilitates synaptic 
 * transmission and plasticity, strengthening connections between neurons. Glutamate 
 * also plays a key role in the fast stress response, enhancing alertness and cognitive 
 * function. However, excessive glutamate activity can lead to excitotoxicity, damaging 
 * neurons and contributing to conditions like anxiety, depression, and neurodegenerative 
 * diseases. Its balance with inhibitory neurotransmitters like GABA is critical for 
 * healthy brain function.
 *
 * Internal, enhancing:
 * - High dopamine, norepinephrine, acetylcholine, cortisol, insulin
 * - Overfed
 *
 * Internal, reducing: 
 * - High gaba or serotonine
 * - Low dopamine, norepinephrine, insulin, acetylcholine, cortisol
 * - Tired, hungry, low energy

 * External, enhancing
 * - Stimulation: Play-with, talk-to, tickle (if not tired) 
 * - Noise, bright light, feeling hot
 *
 * External, reducing
 * - calm-down, smile
 * - Dark, cool
 */

module nt_glutamate_regulator (
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
assign cool = stimuli[5];
assign hot = stimuli[6];
assign loud = stimuli[8];
assign dark = stimuli[9];
assign bright = stimuli[10];
assign hungry = stimuli[11];
assign overfed = stimuli[12];
assign tired = stimuli[13];


assign int_enh = (sleep_state != ASLEEP) && 
                 (( overfed        ) ||
                  ( DOP  == 2'b11 ) ||
                  ( NE   == 2'b11 ) ||
                  ( ACH  == 2'b11 ) ||
                  ( INS  == 2'b11 ) ||
                  ( CORT == 2'b11 ) ||
                  ( GABA == 2'b00 )
                 );

assign int_red = (sleep_state == ASLEEP) ||
                 (( tired         )  ||
                  ( hungry        )  ||
                  ( GABA == 2'b11 )  ||
                  ( GABA == 2'b10 )  ||
                  ( SER  == 2'b11 )  ||
                  ( DOP  == 2'b00 )  ||
                  ( NE   == 2'b00 )  ||
                  ( INS  == 2'b00 )  ||
                  ( ACH  == 2'b00 )  ||
                  ( CORT == 2'b00 )
                 );

assign ext_enh = (play_with || talk_to || tickle || loud || bright || hot);

assign ext_red = (calm_down || dark || cool );

// Truth table
assign inc = (int_enh && !ext_enh && !ext_red) || (!int_enh && ext_enh && !int_red) || (int_enh && ext_enh);
assign dec = !int_enh && !ext_enh && (int_red || ext_red);
assign fast = (int_enh && ext_enh) || (!int_enh && !ext_enh && int_red && ext_red);

endmodule