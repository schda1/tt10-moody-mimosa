/* verilator lint_off UNUSEDSIGNAL */
`default_nettype none

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

  wire [1:0] ACH, DOP, GABA, GLUT, INS, SER;
  wire stessed, hungry, overfed, tired;
  wire tickle, play_with, talk_to, calm_down;
  wire hot, loud, bright;

  /* Neurotransmitter levels */
  assign ACH = neurotransmitter_level[1:0];
  assign DOP = neurotransmitter_level[5:4];
  assign GABA = neurotransmitter_level[7:6];
  assign GLUT = neurotransmitter_level[9:8];
  assign INS = neurotransmitter_level[11:10];
  assign SER = neurotransmitter_level[15:14];

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


  assign int_enh =  (hungry) ||
                    ((sleep_state != ASLEEP) && 
                     (( hungry        ) ||
                      ( tired         ) ||
                      ( GABA == 2'b00 ) ||
                      ( INS  == 2'b00 ) ||
                      ( INS  == 2'b11 ) ||
                      ( DOP  == 2'b11 ) ||
                      ( GLUT == 2'b11 ) ||
                      ( ACH  == 2'b11 )
                    ));

  assign int_red = (sleep_state == ASLEEP) || 
                   (( GABA == 2'b11 )  ||
                    ( INS  == 2'b01 )  ||
                    ( INS  == 2'b10 )  ||
                    ( SER  == 2'b11 )
                   );

  assign ext_enh = (((sleep_state == ASLEEP) && 
                     ( tickle || play_with || talk_to || calm_down || hot || loud || bright)) || 
                    ((sleep_state != ASLEEP) && ( tired || hungry || overfed ) && 
                     (tickle || play_with || talk_to || loud || bright)) ||
                    (hot)
                   );

  assign ext_red = (sleep_state != ASLEEP) && (~tired) && (calm_down);

  // Truth table
  assign inc = (int_enh && !ext_enh && !ext_red) || (!int_enh && ext_enh && !int_red) || (int_enh && ext_enh);
  assign dec = !int_enh && !ext_enh && (int_red || ext_red);
  assign fast = (int_enh && ext_enh) || (!int_enh && !ext_enh && int_red && ext_red);

endmodule