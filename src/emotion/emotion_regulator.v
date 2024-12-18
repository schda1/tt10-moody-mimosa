`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */
`endif
`default_nettype none

module emotion_regulator (
    input wire sleep_state, 
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

/* Happy */
assign emotional_state[0] = (!sleep_state) && 
                            ((NE    == 2'b00 || NE   == 2'b01) && 
                             (CORT  == 2'b00 || CORT == 2'b01) &&
                             ((SER  == 2'b10 || SER  == 2'b11) ||
                              (DOP  == 2'b10 || DOP  == 2'b11) ||
                              (GABA == 2'b10 || GABA == 2'b11))
                            );

/* Excited */
assign emotional_state[1] = (!sleep_state) && 
                            ((NE    == 2'b10 || NE   == 2'b11) && 
                             (CORT  == 2'b00 || CORT == 2'b01) &&
                             (CORT  == 2'b00 || CORT == 2'b01) &&
                             (CORT  == 2'b10 || CORT == 2'b11) &&
                             (GLUT  == 2'b10 || GLUT == 2'b11)
                            );

/* Stressed */
assign emotional_state[2] = (!sleep_state) && 
                            ((NE    == 2'b11) && 
                             (CORT  == 2'b00 || CORT == 2'b11) &&
                             ((SER  == 2'b00 || SER  == 2'b01) ||
                              (GABA == 2'b00 || GABA == 2'b01))
                            );

/* Nervous */
assign emotional_state[3] = (!sleep_state) && 
                            ((NE   == 2'b10) && 
                             (CORT == 2'b10 || CORT == 2'b11) &&
                             ((GABA == 2'b00 || GABA == 2'b01) ||
                              (SER  == 2'b00 || SER  == 2'b01))
                            );

/* Bored */
assign emotional_state[4] = (!sleep_state) && 
                            (((DOP  == 2'b00 || DOP  == 2'b01) || 
                              (GLUT == 2'b00 || GLUT == 2'b01)) && 
                              (SER  == 2'b10 || SER  == 2'b11)
                            );

/* Angry */
assign emotional_state[5] = (!sleep_state) && 
                            ((NE    == 2'b10 || NE   == 2'b11) &&
                             (CORT  == 2'b00 || CORT == 2'b11) &&
                             (DOP   == 2'b00 || DOP  == 2'b01) &&
                             ((GABA == 2'b00 || GABA == 2'b01) ||
                              (SER  == 2'b00 || SER  == 2'b01))
                            );
                          
/* Calm, amused */
assign emotional_state[6] = (!sleep_state) && 
                            ((NE    == 2'b00 || NE   == 2'b01) &&
                             (CORT  == 2'b00 || CORT == 2'b01) &&
                             (DOP   == 2'b00 || DOP  == 2'b01) &&
                             ((GABA == 2'b10 || GABA == 2'b11) ||
                              (SER  == 2'b10 || SER  == 2'b11))
                            );

/* Apathetic */
assign emotional_state[7] = (!sleep_state) && 
                            ((NE    == 2'b00 || NE   == 2'b01) &&
                             (CORT  == 2'b11) &&
                             (SER   == 2'b00)
                            );


wire _unused = &{sleep_state, 1'b0};

endmodule