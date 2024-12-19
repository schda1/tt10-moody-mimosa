`default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

module nt_neurotransmitter_level #(
    parameter N = 8,             // Bit width
    parameter SET_VAL = 0,       // Value to set with setval
    parameter DEFAULT_VAL = 2,   // Default value on reset
    parameter FAST_STEP = 3      // Step size for fast adjustments
) (
    input wire clk,              // Clock input
    input wire rst_n,            // Reset input
    input wire inc,              // Increment signal
    input wire dec,              // Decrement signal
    input wire fast,             // Fast adjustment signal
    input wire setval,           // Set to defined value
    output reg [N-1:0] value     // N-bit value output
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            value <= DEFAULT_VAL;
        end else if (setval) begin
            value <= SET_VAL;
        end else begin
            case ({inc, dec})
                2'b10: begin
                    if (fast) begin
                        if (value <= {N{1'b1}} - FAST_STEP)
                            value <= value + FAST_STEP;
                        else
                            value <= {N{1'b1}};
                    end else if (~&value) begin
                        value <= value + 1;
                    end
                end
                2'b01: begin
                    if (fast) begin
                        if (value >= FAST_STEP)
                            value <= value - FAST_STEP;
                        else
                            value <= 0;
                    end else if (|value) begin
                        value <= value - 1;
                    end
                end
                default: ;
            endcase
        end
    end

endmodule