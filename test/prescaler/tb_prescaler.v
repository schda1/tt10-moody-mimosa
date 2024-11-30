`default_nettype none
`timescale 1ns / 1ps

module tb_prescaler ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_prescaler.vcd");
    $dumpvars(0, tb_prescaler);
    #1;
  end

  // Wire up the inputs and outputs:
  reg rst_n;
  reg clk;
  wire clk_out_div_4;
  wire clk_out_div_10;
  wire clk_out_div_32;
  
  // Instantiate prescaler modules
  prescaler #(.DIV_FACTOR(4)) dut_div_4 (
      .clk (clk),   
      .rst_n (rst_n), 
      .clk_out (clk_out_div_4)
  );

  prescaler #(.DIV_FACTOR(10)) dut_div_10 (
      .clk (clk),   
      .rst_n (rst_n), 
      .clk_out (clk_out_div_10)
  );

  prescaler #(.DIV_FACTOR(32)) dut_div_32 (
      .clk (clk),   
      .rst_n (rst_n), 
      .clk_out (clk_out_div_32)
  );

endmodule
