`default_nettype none
`timescale 1ns / 1ps

module tb_range_classifier ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_range_classifier.vcd");
    $dumpvars(0, tb_range_classifier);
    #1;
  end

  // Wire up the inputs and outputs:
  reg [6:0] number;
  wire [1:0] out_bits;
  reg clk;

  // Instantiate range classifier module 
  range_classifier dut (
      .number  (number),   
      .out_bits (out_bits)
  );

endmodule
