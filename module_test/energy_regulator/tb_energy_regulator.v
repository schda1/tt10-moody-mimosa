`default_nettype none
`timescale 1ns / 1ps

module tb_energy_regulator ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_energy_regulator.vcd");
    $dumpvars(0, tb_energy_regulator);
    #1;
  end

  // Wire up the inputs and outputs:
  reg state_controller_inc;
  reg state_controller_dec;
  reg energy_inc;
  reg energy_dec;

  // Instantiate energy_regulator classifier module 
  energy_regulator dut (
      .state_controller_inc (state_controller_inc),   
      .state_controller_dec (state_controller_dec),
      .energy_inc (energy_inc),
      .energy_dec (energy_dec)
  );

endmodule
