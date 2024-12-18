`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module sleep_regulator (
    input wire [15:0] neurotransmitter_level,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    input wire [1:0] vital_energy_level,
    input wire vital_energy_zero,
    output wire wake_up_signal,
    output wire sleep_in_signal
);

    wire [1:0] NE, CORT, ACH, DOP, GABA, GLUT, INS, SER;
    wire hungry, hot, loud, bright;
    wire tickle, play_with, talk_to;

    /* Neurotransmitter levels */
    assign ACH  = neurotransmitter_level[1:0];
    assign CORT = neurotransmitter_level[3:2];
    assign DOP  = neurotransmitter_level[5:4];
    assign GABA = neurotransmitter_level[7:6];
    assign GLUT = neurotransmitter_level[9:8];
    assign INS  = neurotransmitter_level[11:10];
    assign NE   = neurotransmitter_level[13:12];
    assign SER  = neurotransmitter_level[15:14];

    /* Stimuli */
    assign tickle = stimuli[0];
    assign play_with = stimuli[1];
    assign talk_to = stimuli[2];
    assign hot = stimuli[6];
    assign loud = stimuli[8];
    assign bright = stimuli[10];
    assign hungry = stimuli[11];

    assign sleep_in_signal = (vital_energy_zero              ) ||
                             ((vital_energy_level == 2'b00    ) && 
                              (NE   == 2'b00 || NE   == 2'b01 ) &&
                              (CORT == 2'b00 || CORT == 2'b01 ) &&
                              (!tickle && !play_with && !talk_to && !hot && !bright && !loud && !hungry)
                             );

    assign wake_up_signal =  (vital_energy_level == 2'b11    ) || 
                             (vital_energy_level != 2'b00    ) && 
                             ((NE   == 2'b10 || NE   == 2'b11 ) || 
                              (CORT == 2'b10 || CORT == 2'b11 ) ||
                              (tickle || play_with || talk_to || hot || bright || loud || hungry)
                             );

endmodule
