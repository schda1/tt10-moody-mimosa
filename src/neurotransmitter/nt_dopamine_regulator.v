`default_nettype none

module nt_dopamine_regulator (
    input wire [15:0] neurotransmitter_level,   
    input wire [7:0] emotional_state,
    input wire [15:0] stimuli,
    input wire [7:0] action, 
    input wire [1:0] sleep_state,
    output wire inc,
    output wire dec,
    output wire fast
);

assign inc = 0;
assign dec = 0;
assign fast = 0;

endmodule