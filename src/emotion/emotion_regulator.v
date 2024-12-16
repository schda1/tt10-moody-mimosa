`default_nettype none

module emotion_regulator (
    input wire [1:0] sleep_state, 
    input wire [15:0] neurotransmitter_level,
    output wire [7:0] emotional_state
);

wire [1:0] ACH, DOP, GABA, GLUT, INS, SER, CORT, NE;

/* Neurotransmitter levels */
assign ACH  = neurotransmitter_level[1:0];
assign CORT = neurotransmitter_level[3:2];
assign DOP  = neurotransmitter_level[5:4];
assign GABA = neurotransmitter_level[7:6];
assign GLUT = neurotransmitter_level[9:8];
assign INS  = neurotransmitter_level[11:10];
assign NE   = neurotransmitter_level[13:12];
assign SER  = neurotransmitter_level[15:14];

assign emotional_state[0] = (ACH == 2'b11);
assign emotional_state[1] = (CORT == 2'b11);
assign emotional_state[2] = (DOP == 2'b11);
assign emotional_state[3] = (GABA == 2'b11);
assign emotional_state[4] = (GLUT == 2'b11);
assign emotional_state[5] = (INS == 2'b11);
assign emotional_state[6] = (NE == 2'b11);
assign emotional_state[7] = (SER == 2'b11);

endmodule