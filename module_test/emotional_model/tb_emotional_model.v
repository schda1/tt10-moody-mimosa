`default_nettype none
`timescale 1ns / 1ps

module tb_emotional_model ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_emotional_model.vcd");
    $dumpvars(0, tb_emotional_model);
    #1;
  end

  // Wire up the inputs and outputs:
  reg [1:0] energy;
  reg [1:0] stress;
  reg [1:0] pleasure;
  reg [1:0] physical_state;
  wire [7:0] emotion;

  // Instantiate emotional_model classifier module 
  emotional_model dut (
      .energy (energy),   
      .stress (stress),
      .pleasure (pleasure),   
      .emotion (emotion),
      .physical_state (physical_state)
  );

endmodule
