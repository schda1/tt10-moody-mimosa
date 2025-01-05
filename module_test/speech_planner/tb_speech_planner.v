`default_nettype none
`timescale 1ns / 1ps

module tb_speech_planner ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_speech_planner.vcd");
    $dumpvars(0, tb_speech_planner);
    #1;
  end

  reg clk;
  reg rst_n;
  reg [7:0] emotional_state;
  reg [7:0] action;
  reg [1:0] development_stage;
  wire [12:0] address;

  speech_planner planner (
    .clk(clk),
    .nrst(rst_n),
    .emotional_state(emotional_state),
    .action(action),
    .development_stage(development_stage),
    .address(address)
  );


endmodule