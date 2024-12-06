`default_nettype none
`timescale 1ns / 1ps

module tb_static_clock_divider ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_static_clock_divider.vcd");
    $dumpvars(0, tb_static_clock_divider);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  wire clk_out_by_2;
  wire clk_out_by_4; 
  wire clk_out_by_8;
  
  // Instantiate saturating counter modules

  static_clock_divider #(.N(1)) dut_clock_divider_by_2 (
      .clk (clk),  
      .rst_n (rst_n), 
      .clk_out (clk_out_by_2)
  );

  static_clock_divider #(.N(2)) dut_clock_divider_by_4 (
      .clk (clk),  
      .rst_n (rst_n), 
      .clk_out (clk_out_by_4)
  );

  static_clock_divider #(.N(3)) dut_clock_divider_by_8 (
      .clk (clk),  
      .rst_n (rst_n), 
      .clk_out (clk_out_by_8)
  );

endmodule