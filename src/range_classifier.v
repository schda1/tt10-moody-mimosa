`default_nettype none

module range_classifier #(parameter N = 7) (
    input  [N-1:0] number,   // N-bit input number
    output [1:0] out_bits    // 2-bit output representing the range classifier
);

    assign out_bits = (number[N-1:N-2] == 2'b11) ? 2'b10 :   // Upper 1/4
                      (number[N-1:N-2] == 2'b00) ? 2'b00 :   // Lower 1/4
                                                   2'b01 ;   // Middle 1/2

endmodule