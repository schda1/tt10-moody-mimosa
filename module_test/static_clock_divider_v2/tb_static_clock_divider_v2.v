`default_nettype none
`timescale 1ns / 1ps

module tb_static_clock_divider_v2 ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_static_clock_divider_v2.vcd");
    $dumpvars(0, tb_static_clock_divider_v2);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  wire clk_out_by_2;
  wire clk_out_by_4; 
  wire clk_out_by_10;
  

  static_clock_divider_v2 #(.PRESCALER(2)) dut_clock_divider_by_2 (
      .clk (clk),  
      .rst_n (rst_n), 
      .clk_out (clk_out_by_2)
  );

  static_clock_divider_v2 #(.PRESCALER(4)) dut_clock_divider_by_4 (
      .clk (clk),  
      .rst_n (rst_n), 
      .clk_out (clk_out_by_4)
  );

  static_clock_divider_v2 #(.PRESCALER(10)) dut_clock_divider_by_10 (
      .clk (clk),  
      .rst_n (rst_n), 
      .clk_out (clk_out_by_10)
  );

endmodule