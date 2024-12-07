`default_nettype none
`timescale 1ns / 1ps

module tb_dynamic_clock_divider ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_dynamic_clock_divider.vcd");
    $dumpvars(0, tb_dynamic_clock_divider);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg [1:0] x_2bit;
  reg [3:0] x_4bit;
  wire clk_out_2bit;
  wire clk_out_4bit;
  
  // Instantiate saturating counter modules
  dynamic_clock_divider #(.N(2)) dut_clock_divider_2bit (
      .clk (clk),   
      .rst_n (rst_n),
      .x (x_2bit), 
      .clk_out (clk_out_2bit)
  );

  dynamic_clock_divider #(.N(4)) dut_clock_divider_4bit (
      .clk (clk),  
      .rst_n (rst_n), 
      .x (x_4bit), 
      .clk_out (clk_out_4bit)
  );

endmodule