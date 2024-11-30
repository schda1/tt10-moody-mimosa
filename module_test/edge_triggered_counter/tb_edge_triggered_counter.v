`default_nettype none
`timescale 1ns / 1ps

module tb_edge_triggered_counter ();

  // Dump the signals to a VCD file.
  initial begin
    $dumpfile("tb_edge_triggered_counter.vcd");
    $dumpvars(0, tb_edge_triggered_counter);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ext_in;
  wire[3:0] counter;

  // Instantiate module
  edge_triggered_counter dut (
      .clk  (clk),  
      .rst_n (rst_n),   
      .ext_in (ext_in),  
      .counter(counter)
  );

endmodule