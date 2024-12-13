`default_nettype none

module nourishment_regulator (
    input wire [1:0] sleep_state,
    input wire [15:0] neurotransmitter_level,
    input wire [15:0] stimuli,
    input wire [7:0] emotional_state,
    input wire [1:0] heartbeat,
    output wire hungry,
    output wire overfed
);

assign hungry = 0;
assign overfed = 0;

endmodule