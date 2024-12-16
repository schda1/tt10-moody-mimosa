/* verilator lint_off UNUSEDSIGNAL */
`default_nettype none

module heartbeat_regulator (
    input wire [1:0] sleep_state,
    input wire [15:0] neurotransmitter_level, 
    input wire [15:0] stimuli,
    input wire [7:0] emotional_state,
    output wire [1:0] heartbeat
);

assign heartbeat = 0;

wire _unused = &{sleep_state, neurotransmitter_level, stimuli, emotional_state, 1'b0};

endmodule