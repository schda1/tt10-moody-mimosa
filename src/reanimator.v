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
    reg stimulus_d;
    wire stimulus_rising_edge; 

    // Synchronize the stimulus signal with the clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stimulus_d <= 0;
        end else begin
            stimulus_d <= stimulus;
        end
    end

    // Detect rising edge of the stimulus (0 to 1 transition)
    assign stimulus_rising_edge = stimulus && !stimulus_d;

    saturating_counter #(.N(COUNTER_WIDTH), .SET_VAL(0), .DEFAULT_VAL(0)) counter_inst (
        .clk(clk),
        .rst_n(rst_n),
        .inc(stimulus_rising_edge && state == 2),
        .dec(1'b0),                   
        .setval(state == 0 || state == 1 || state == 3), 
        .value(counter_value)
    );

    // Determine if reanimated based on the counter value and state
    always @(*) begin
        reanimated = (state == 2 && counter_value > COUNTER_LIMIT);
    end

endmodule
