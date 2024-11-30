module prescaler #(parameter DIV_FACTOR = 4) (
    input wire clk,        // Input clock
    input wire rst_n,      // Active-low reset
    output reg clk_out     // Prescaled clock output
);

    // Use a small counter (max 3 bits for DIV_FACTOR <= 16)
    reg [2:0] div_counter;  

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_counter <= 0;
            clk_out <= 0;  // Reset output clock to 0
        end else begin
            // Count up to half the division factor (DIV_FACTOR / 2)
            if (div_counter == (DIV_FACTOR / 2 - 1)) begin
                div_counter <= 0;    // Reset after half-period
                clk_out <= ~clk_out; // Toggle the output clock
            end else begin
                div_counter <= div_counter + 1;  // Increment counter
            end
        end
    end
    
endmodule