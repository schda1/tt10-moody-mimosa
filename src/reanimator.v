module reanimator #(
    parameter COUNTER_LIMIT = 10, // Threshold for reanimated
    parameter COUNTER_WIDTH = 8   // Bit-width of the counter
) (
    input wire clk,
    input wire rst_n,
    input wire stimulus, 
    input wire [1:0] state,
    output reg reanimated
);

    wire [COUNTER_WIDTH-1:0] counter_value;

    saturating_counter #(
        .N(COUNTER_WIDTH),
        .SET_VAL(0), 
        .DEFAULT_VAL(0)
    ) counter_inst (
        .clk(clk),
        .rst_n(rst_n),
        .inc(state == 2 && stimulus),
        .dec(1'b0),                   
        .setval(state == 0 || state == 1),
        .value(counter_value)
    );

    always @(*) begin
        reanimated = (state == 2 && counter_value > COUNTER_LIMIT);
    end

endmodule
