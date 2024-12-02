`default_nettype none

module dynamic_clock_divider #(parameter N = 2)(
    input wire clk,                 // Input clock signal
    input wire rst_n,               // Active-low reset signal
    input wire [N-1:0] x,           // N-bit control input to select frequency division
    output reg clk_out              // Output clock signal
);

    reg [N-1:0] div_count;

    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (~rst_n) begin
            div_count <= 0;
            clk_out <= 0;
        end else begin
            if (x == 0) begin
                clk_out <= clk;
                div_count <= 0;
            end else begin
                if (div_count == (x)) begin
                    clk_out <= ~clk_out; // Toggle clk_out when div_count matches
                    div_count <= 0;      // Reset counter after toggle
                end else begin
                    div_count <= div_count + 1; // Increment the counter
                end
            end
        end
    end

endmodule