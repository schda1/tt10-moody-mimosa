`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module sleep_regulator (
    input wire [9:0] neurotransmitter_level,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    input wire [1:0] vital_energy_level,
    input wire vital_energy_zero,
    output wire wake_up_signal,
    output wire sleep_in_signal
);

    wire [1:0] NE, CORT, DOP, GABA, SER;
    wire hungry, starving, hot, loud, bright;
    wire tickle, play_with, talk_to;

    /* Neurotransmitter levels */
    assign CORT = neurotransmitter_level[1:0];
    assign DOP  = neurotransmitter_level[3:2];
    assign GABA = neurotransmitter_level[5:4];
    assign NE   = neurotransmitter_level[7:6];
    assign SER  = neurotransmitter_level[9:8];

    /* Stimuli */
    assign tickle    = stimuli[0];
    assign play_with = stimuli[1];
    assign talk_to   = stimuli[2];
    assign hot       = stimuli[6];
    assign loud      = stimuli[8];
    assign bright    = stimuli[10];
    assign hungry    = stimuli[11];
    assign starving  = stimuli[12];

    /* Asleep */
    wire is_asleep;
    assign is_asleep = action[0];

    assign sleep_in_signal = (!is_asleep) && 
                             ((vital_energy_zero               ) ||
                              ((vital_energy_level == 2'b00    ) &&
                               (NE   == 2'b00 || NE   == 2'b01 ) &&
                               (CORT == 2'b00 || CORT == 2'b01 ) &&
                               (!tickle && !play_with && !talk_to && !hot && !bright && !loud && !starving)
                              )
                             );

    assign wake_up_signal =  (is_asleep) && 
                             ((vital_energy_level == 2'b11    ) ||
                              ((vital_energy_level != 2'b00     ) &&
                               ((NE   == 2'b10 || NE   == 2'b11 ) ||
                                (CORT == 2'b10 || CORT == 2'b11 ) ||
                                (tickle || play_with || talk_to || hot || bright || loud || starving))
                              )
                             );

endmodule