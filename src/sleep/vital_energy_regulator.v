/* verilator lint_off UNUSEDSIGNAL */
`default_nettype none

/** 
 * Model: 
 * - If asleep and 00/01: setval
 * - If asleep and NE-/CORT-/GABA+: inc fast
 * - If asleep otherwise: inc
 * - If awake: dec
 * - If awake and NE+/CORT+/GABA-/SER- or play_with: dec fast
 */ 

module vital_energy_regulator (
    input wire [15:0] neurotransmitter_level,
    input wire [15:0] stimuli,
    input wire [7:0] action, 
    input wire [1:0] sleep_state,
    output wire inc,
    output wire dec,
    output wire fast,
    output wire setval
); 

    localparam ASLEEP = 2'b00;  

    wire play_with;
    wire [1:0] ACH, DOP, GABA, GLUT, INS, SER, CORT, NE;

    assign ACH  = neurotransmitter_level[1:0];
    assign CORT = neurotransmitter_level[3:2];
    assign DOP  = neurotransmitter_level[5:4];
    assign GABA = neurotransmitter_level[7:6];
    assign GLUT = neurotransmitter_level[9:8];
    assign INS  = neurotransmitter_level[11:10];
    assign NE   = neurotransmitter_level[13:12];
    assign SER  = neurotransmitter_level[15:14];

    assign setval = 0;
    assign inc = (sleep_state == ASLEEP);
    assign dec = (sleep_state != ASLEEP);
    assign play_with = stimuli[1];

    assign fast = ((sleep_state == ASLEEP) && 
                   (NE   == 2'b00 ) ||
                   (NE   == 2'b01 ) ||
                   (CORT == 2'b00 ) ||
                   (CORT == 2'b01 ) ||
                   (GABA != 2'b00 )) ||
                  ((sleep_state != ASLEEP) && 
                   (NE   == 2'b11 ) ||
                   (NE   == 2'b10 ) ||
                   (CORT == 2'b11 ) ||
                   (CORT == 2'b10 ) ||
                   (SER  == 2'b00 ) ||
                   (play_with     ));

endmodule