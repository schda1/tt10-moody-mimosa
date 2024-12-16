`default_nettype none

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
 * - High ACH, Glutamate
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
                 (( tired || hungry ) ||
                  ( CORT == 2'b00   ) ||
                  ( CORT == 2'b01   ) ||
                  ( NE   == 2'b00   ) ||
                  ( NE   == 2'b01   ) ||
                  ( GABA == 2'b00   ) ||
                  ( GABA == 2'b01   ) ||
                  ( INS  == 2'b00   ) ||
                  ( ACH  == 2'b11   ) ||
                  ( GLUT == 2'b11   )
                 );

assign int_red = (sleep_state == ASLEEP) ||
                 (( overfed        ) ||
                  ( tired && hungry) ||
                  ( CORT == 2'b11  ) ||
                  ( NE   == 2'b11  ) ||
                  ( SER  == 2'b11  ) ||
                  ( GABA == 2'b11  ) ||
                  ( INS  == 2'b11  ) ||
                  ( ACH  == 2'b00  ) ||
                  ( GLUT == 2'b00  )
                 );

assign ext_enh = (sleep_state != ASLEEP) &&
                 ((bright || cool) || ((~tired) && (talk_to || play_with)));

assign ext_red = (sleep_state != ASLEEP) && 
                 ((loud || hot) || ((~tired) && (bright || talk_to || play_with)));

// Truth table (reducing dominant)
assign inc = (!int_red && !ext_red);
assign dec = (!ext_enh && int_red && !ext_red) || (!int_enh && !int_red && ext_red) || (int_red && ext_red);
assign fast = (int_red && ext_red) || (int_enh && ext_enh && !int_red && !ext_red);

endmodule