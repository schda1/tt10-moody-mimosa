`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module illness_system (
    input wire clk,
    input wire rst_n,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    input wire [9:0] neurotransmitter_level,
    output reg ill
    `ifdef PY_SIM
    , output wire [8:0] dbg_illness
    `endif
);

    wire inc, dec, fast, setval;
    wire [1:0] illness_level;
    wire [8:0] illness;

    assign illness_level = illness[8:7];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ill <= 1'b0; 
        end else begin
            if (!ill && illness_level == 2'b11) begin
                ill <= 1'b1;
            end else if (ill && illness_level == 2'b00) begin
                ill <= 1'b0;
            end
        end
    end

    illness_regulator illness_reg (
        .stimuli(stimuli),
        .action(action),
        .neurotransmitter_level (neurotransmitter_level),
        .illness_level(illness_level),
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval)
    );

    /* energy resource */
    resource #(
        .N(9),
        .SET_VAL(128),
        .DEFAULT_VAL(128),
        .FAST_STEP(4)
    ) illness_resource (
        .clk(clk),
        .rst_n(rst_n),
        .inc(inc),
        .dec(dec),
        .fast(fast),
        .setval(setval),
        .value(illness)
    );

    `ifdef PY_SIM
    assign dbg_illness = illness;
    `endif

endmodule