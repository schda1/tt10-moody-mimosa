`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module nourishment_system (
    input wire clk,
    input wire rst_n,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    output wire hungry,
    output wire starving
    `ifdef PY_SIM
    , output wire [7:0] dbg_nourishment
    `endif
);
    wire inc, dec, fast, setval;
    wire [1:0] nourishment_level;
    wire [7:0] glucose;

    assign nourishment_level = glucose[7:6];
    assign hungry = (nourishment_level == 2'b01) || (nourishment_level == 2'b00);
    assign starving = (nourishment_level == 2'b00);

    nourishment_regulator nourishment_reg (
        .stimuli(stimuli),
        .action(action),
        .nourishment_level(nourishment_level),
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval)
    );

    /* energy resource */
    resource #(
        .N(8),
        .SET_VAL(128),
        .DEFAULT_VAL(128),
        .FAST_STEP(4)
    ) glucose_resource (
        .clk(clk),
        .rst_n(rst_n),
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval),
        .value(glucose)
    );

    `ifdef PY_SIM
    assign dbg_nourishment = glucose;
    `endif

endmodule