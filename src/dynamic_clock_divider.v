`default_nettype none

module dynamic_clock_divider #(parameter N = 2)(
    input wire clk,                 // Input clock signal
    input wire rst_n,               // Active-low reset signal
    input wire [N-1:0] x,           // N-bit control input to select frequency division
    output reg clk_out              // Output clock signal
);

    reg [N-1:0] div_count;
    reg [N-1:0] x_sync;  // Synchronized x signal
    reg [N-1:0] x_sync_prev;  // Previous value of synchronized x

    // Synchronize the x input to avoid glitches when it changes
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            x_sync <= 0;
            x_sync_prev <= 0;
        end else begin
            x_sync_prev <= x_sync;
            x_sync <= x;
        end
    end

    // Main clock divider logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            div_count <= 0;
            clk_out <= 0;
        end else if (x_sync == 0) begin
            clk_out <= ~clk_out;  // Toggle clk_out every clock edge for x == 0 (division by 1)
            div_count <= 0;       // Reset counter (no division needed)
        end else if (x_sync == 1) begin
            if (div_count == 1) begin
                clk_out <= ~clk_out;  // Toggle clk_out every second clock edge for x == 1 (division by 2)
                div_count <= 0;       // Reset counter after toggle
            end else begin
                div_count <= div_count + 1;  // Increment counter
            end
        end else if (x_sync != x_sync_prev) begin
            // Reset the counter and output when x changes
            div_count <= 0;
            clk_out <= 0;  // Optionally, reset clk_out when x changes (depends on desired behavior)
        end else if (div_count == (x_sync)) begin
            clk_out <= ~clk_out;  // Toggle clk_out when div_count matches x_sync (division by x_sync + 1)
            div_count <= 0;       // Reset counter after toggle
        end else begin
            div_count <= div_count + 1;  // Increment counter
        end
    end

endmodule
