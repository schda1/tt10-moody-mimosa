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
  reg [6:0] number_7bit;
  reg [9:0] number_10bit;
  wire [1:0] out_bits_7bit;
  wire [1:0] out_bits_10bit;
  reg clk;

  // Instantiate range classifier module 
  range_classifier #(.N(7)) dut_range_classifier_7bit (
      .number  (number_7bit),   
      .out_bits (out_bits_7bit)
  );

  range_classifier #(.N(10)) dut_range_classifier_10bit (
      .number  (number_10bit),   
      .out_bits (out_bits_10bit)
  );

endmodule
