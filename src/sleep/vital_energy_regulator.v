`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module vital_energy_regulator (
    input wire [9:0] neurotransmitter_level,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    output wire inc,
    output wire dec,
    output wire fast,
    output wire setval
);
    wire play_with;

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

    assign setval = 0;
    assign inc = sleep;
    assign dec = !sleep;
    assign play_with = stimuli[1];

    assign fast = ((sleep) &&
                   ((NE   == 2'b00 )   ||
                    (NE   == 2'b01 )   ||
                    (CORT == 2'b00 )   ||
                    (CORT == 2'b01 )   ||
                    (GABA != 2'b00 ))) ||
                  ((!sleep) &&
                   ((NE   == 2'b11 )   ||
                    (NE   == 2'b10 )   ||
                    (CORT == 2'b11 )   ||
                    (CORT == 2'b10 )   ||
                    (SER  == 2'b00 )   ||
                    (play          )));

endmodule