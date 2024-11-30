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
  wire clk_out;
  
  // Instantiate prescaler module 
  prescaler dut (
      .clk (clk),   
      .rst_n (rst_n), 
      .clk_out (clk_out)
  );

endmodule
