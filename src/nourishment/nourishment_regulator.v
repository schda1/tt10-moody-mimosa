`default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

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
    input wire [1:0] nourishment_level,
    output wire inc,
    output wire dec,
    output wire fast,
    output wire setval
);

    wire sleep, eat, play, smile, babble, kick_legs, idle, cry;
    assign sleep     = action[0];
    assign eat       = action[1];
    assign setval    = 0;

    assign inc = (!sleep) && eat;
    assign dec = (sleep) || ((!sleep) && (~eat));
    assign fast = (!sleep) && eat;

endmodule