/* verilator lint_off UNUSEDSIGNAL */
`default_nettype none

module vital_energy_system (
    input wire clk,
    input wire rst_n,
    input wire [15:0] neurotransmitter_level,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    input wire [1:0] sleep_state,
    output wire [1:0] vital_energy_level
    `ifdef PY_VERILATOR
    , output wire [6:0] dbg_vital_energy      
    `endif
);
    wire inc, dec, fast, setval;
    wire [6:0] vital_energy;

    assign vital_energy_level = vital_energy[6:5];

    vital_energy_regulator vital_energy_reg (
        .neurotransmitter_level(neurotransmitter_level),
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .inc(inc),
        .dec(dec), 
        .fast(fast),
        .setval(setval)
    );

    /* energy resource */
    nt_neurotransmitter_level #(
        .N(7), 
        .SET_VAL(64), 
        .DEFAULT_VAL(96),
        .FAST_STEP(3)
    ) glucose_resource (
        .clk(clk),
        .rst_n(rst_n), 
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval), 
        .value(vital_energy)
    );

    `ifdef PY_VERILATOR
    assign dbg_vital_energy = vital_energy;
    `endif

    wire _unused = &{vital_energy[4:0], 1'b0};
    
endmodule