`default_nettype none

module static_clock_divider_v2 #(parameter PRESCALER = 128) (
    input wire clk,
    input wire rst_n,
    output reg clk_out
);

    reg [$clog2(PRESCALER/2+1):0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == (PRESCALER/2 - 1)) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule