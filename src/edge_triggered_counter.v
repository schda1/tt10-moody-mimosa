module edge_triggered_counter (
    input wire clk,          // Input clock
    input wire rst_n,        // Active-low reset
    input wire ext_in,       // External signal to trigger counter
    output reg [3:0] counter // 4-bit counter output
);

    reg ext_in_d;  // Delayed version of ext_in to detect rising edge

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 4'b0000;
            ext_in_d <= 0;
        end else begin
            ext_in_d <= ext_in; // Store previous value of ext_in
            // Increment the counter on the rising edge of ext_in
            if (ext_in && !ext_in_d) begin
                counter <= counter + 1;
            end
        end
    end

endmodule