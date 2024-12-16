/* verilator lint_off UNUSEDSIGNAL */
`default_nettype none

module nourishment_system (
    input wire clk,
    input wire rst_n,
    input wire [1:0] sleep_state,
    input wire [15:0] stimuli,
    input wire [7:0] action, 
    output wire hungry,
    output wire overfed
    `ifdef PY_VERILATOR
    , output wire [6:0] dbg_nourishment      
    `endif
);
    wire inc, dec, fast, setval;
    wire [1:0] nourishment_level;
    wire [6:0] glucose;

    assign nourishment_level = glucose[6:5];
    assign hungry = (nourishment_level == 2'b00) || (nourishment_level == 2'b01);
    assign overfed = (nourishment_level == 2'b11);

    nourishment_regulator nourishment_reg (
        .stimuli(stimuli), 
        .action(action), 
        .sleep_state(sleep_state),
        .nourishment_level(nourishment_level),
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
        .value(glucose)
    );

    `ifdef PY_VERILATOR
    assign dbg_nourishment = glucose;
    `endif

    wire _unused = &{sleep_state, glucose[4:0], 1'b0};
    
endmodule