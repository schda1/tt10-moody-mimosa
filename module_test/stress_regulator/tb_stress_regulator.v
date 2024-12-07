`default_nettype none
`timescale 1ns / 1ps

module tb_stress_regulator ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_stress_regulator.vcd");
    $dumpvars(0, tb_stress_regulator);
    #1;
  end

  // Wire up the inputs and outputs:
  reg sleep_controller_inc;
  reg sleep_controller_dec;
  reg [6:0] stimuli;
  wire stress_inc;
  wire stress_dec;

  // Instantiate stess_regulator classifier module 
  stress_regulator dut (
      .sleep_controller_inc (sleep_controller_inc),   
      .sleep_controller_dec (sleep_controller_dec),
      .stimuli (stimuli),
      .stress_inc (stress_inc),
      .stress_dec (stress_dec)
  );

endmodule
