`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

/** 
 * Model: 
 * - If asleep: slow decrease
 * - If awake: fast decrease
 * - If eating: setval (if 00 or 01) + fast increase
 *
 * Truth table: 
 *
 * | Nourishment | Sleep  | Eating  | inc | dec | fast | setval |
 * | ----------- | ------ | ------- | --- | --- | ---- | ------ |
 * | xx          | asleep | x       | 0   | 1   | 0    | 0      |
 * | xx          | awake  | 0       | 0   | 1   | 1    | 0      |
 * | 0x          | awake  | 1       | 1   | 0   | 1    | 1      |
 * | 1x          | awake  | 1       | 1   | 0   | 1    | 1      |
 *
 */ 

module nourishment_regulator (
    input wire [15:0] stimuli,
    input wire [7:0] action, 
    input wire sleep_state,
    input wire [1:0] nourishment_level,
    output wire inc,
    output wire dec,
    output wire fast,
    output wire setval
);

    localparam ASLEEP = 1'b0;  

    wire feed;
    assign feed = stimuli[4];
    assign setval = 0;

    assign inc = (sleep_state != ASLEEP) && feed;
    assign dec = (sleep_state == ASLEEP) || ((sleep_state != ASLEEP) && (~feed));
    assign fast = (sleep_state != ASLEEP) && feed;

endmodule