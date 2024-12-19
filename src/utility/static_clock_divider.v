`default_nettype none

module static_clock_divider #(parameter N = 4) (
    input wire clk,
    input wire rst_n,
    output wire clk_out
);

    reg [N-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    // Use the MSB of the counter as the divided clock
    assign clk_out = counter[N-1];

endmodule