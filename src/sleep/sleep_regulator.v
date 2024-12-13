`default_nettype none

module sleep_regulator (
    input wire [15:0] neurotransmitter_level,
    input wire [7:0] emotional_state,
    output wire [1:0] sleep_state
); 

assign sleep_state = 0;

endmodule