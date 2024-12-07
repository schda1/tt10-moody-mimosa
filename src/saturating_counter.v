`default_nettype none

module saturating_counter #(parameter N = 8, parameter SET_VAL = 0, parameter DEFAULT_VAL = 2) (
    input wire clk,              // Clock input
    input wire rst_n,            // Reset input
    input wire inc,              // Increment signal
    input wire dec,              // Decrement signal
    input wire setval,           // Set to defined value
    output reg [N-1:0] value     // N-bit value output
);

    always @(posedge clk) begin
        if (!rst_n) begin
            value <= DEFAULT_VAL;
        end else if (setval) begin
            value <= SET_VAL;
        end else begin
            case ({inc, dec})
                2'b10: if (~&value) value <= value + 1;  // Increment if not max
                2'b01: if (|value)  value <= value - 1;  // Decrement if not zero
                default: ;                               // No change if both or neither active
            endcase
        end
    end

endmodule