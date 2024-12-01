`default_nettype none
`timescale 1ns / 1ps

module tb_saturating_counter ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_saturating_counter.vcd");
    $dumpvars(0, tb_saturating_counter);
    #1;
  end

  // Wire up the inputs and outputs:
  reg rst_n;
  reg clk;
  reg inc;
  reg dec;

  wire [1:0] value_2bit;
  wire [7:0] value_8bit;
  wire [15:0] value_16bit;
  
  
  // Instantiate saturating counter modules
  saturating_counter #(.N(2)) dut_counter_2bit (
      .clk (clk),   
      .rst_n (rst_n), 
      .inc (inc), 
      .dec (dec), 
      .value (value_2bit)
  );

  saturating_counter #(.N(8)) dut_counter_8bit (
      .clk (clk),   
      .rst_n (rst_n), 
      .inc (inc), 
      .dec (dec), 
      .value (value_8bit)
  );

  saturating_counter #(.N(16)) dut_counter_16bit (
      .clk (clk),   
      .rst_n (rst_n), 
      .inc (inc), 
      .dec (dec), 
      .value (value_16bit)
  );

endmodule