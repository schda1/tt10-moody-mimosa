/* verilator lint_off UNUSEDSIGNAL */
`default_nettype none

module action_regulator (
    input wire [15:0] stimuli,
    input wire [7:0] emotional_state, 
    input wire [1:0] sleep_state, 
    output wire [7:0] action
);

assign action = 0;

wire _unused = &{stimuli, emotional_state, sleep_state, 1'b0};

endmodule