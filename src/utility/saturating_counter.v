`default_nettype none

module saturating_counter #(parameter N = 8, parameter SET_VAL = 0, parameter DEFAULT_VAL = 2) (
    input wire clk,
    input wire rst_n,
    input wire inc,
    input wire dec,
    input wire setval,
    output reg [N-1:0] value
);

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            value <= DEFAULT_VAL;
        end else if (setval) begin
            value <= SET_VAL;
        end else begin
            case ({inc, dec})
                2'b10: if (~&value) value <= value + 1; 
                2'b01: if (|value)  value <= value - 1;
                default: ;
            endcase
        end
    end

endmodule