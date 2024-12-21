`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module vital_energy_system (
    input wire clk,
    input wire rst_n,
    input wire [9:0] neurotransmitter_level,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    output wire [1:0] vital_energy_level,
    output wire vital_energy_zero
    `ifdef PY_SIM
    , output wire [7:0] dbg_vital_energy
    `endif
);
    wire inc, dec, fast, setval;
    wire [7:0] vital_energy;

    assign vital_energy_level = vital_energy[7:6];
    assign vital_energy_zero = (vital_energy == 0);

    /* Vital energy regulation */
    vital_energy_regulator vital_energy_reg (
        .neurotransmitter_level(neurotransmitter_level),
        .stimuli(stimuli),
        .action(action),
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval)
    );

    /* Vital energy resource */
    nt_neurotransmitter_level #(
        .N(8),
        .SET_VAL(64),
        .DEFAULT_VAL(128),
        .FAST_STEP(4)
    ) vital_energy_resource (
        .clk(clk),
        .rst_n(rst_n),
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval),
        .value(vital_energy)
    );

    `ifdef PY_SIM
    assign dbg_vital_energy = vital_energy;
    `endif

endmodule