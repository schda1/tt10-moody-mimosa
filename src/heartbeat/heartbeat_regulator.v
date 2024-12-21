`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module heartbeat_regulator (
    input wire [7:0] action,
    input wire [9:0] neurotransmitter_level,
    input wire [15:0] stimuli,
    input wire [7:0] emotional_state,
    output wire [1:0] heartbeat
);

assign heartbeat = 0;

endmodule