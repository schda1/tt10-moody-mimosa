`default_nettype none

module action_regulator (
    input wire [15:0] stimuli,
    input wire [7:0] emotional_state, 
    input wire [1:0] sleep_state, 
    output wire [7:0] action
);

assign action = 0;

endmodule