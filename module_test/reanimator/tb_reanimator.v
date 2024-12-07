`default_nettype none
`timescale 1ns / 1ps

module tb_reanimator ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_reanimator.vcd");
    $dumpvars(0, tb_reanimator);
    #1;
  end

  // Wire up the inputs and outputs:
  reg rst_n;
  reg clk;
  reg stimulus;
  reg [1:0] state;
  wire reanimated;

  // Instantiate saturating counter modules
  reanimator #(.COUNTER_LIMIT(4), .COUNTER_WIDTH(4)) dut_reanimator (
      .clk (clk),   
      .rst_n (rst_n), 
      .stimulus (stimulus), 
      .state (state), 
      .reanimated (reanimated)
  );

endmodule