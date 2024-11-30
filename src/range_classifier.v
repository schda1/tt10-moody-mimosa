
module range_classifier (
    input  [6:0] number,   // 7-bit input number
    output [1:0] out_bits  // 2-bit output representing the range
);

    // The output 'out_bits' is encoded as follows:
    // 00: number <= 31
    // 01: 32 <= number <= 95
    // 10: number >= 96

    assign out_bits = (number[6:5] == 2'b11) ? 2'b10 :  // Range 96 to 127
                      (number[6:5] == 2'b00) ? 2'b00 :  // Range 0 to 31
                                               2'b01;   // Range 32 to 95

endmodule