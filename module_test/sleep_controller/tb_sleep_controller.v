`default_nettype none
`timescale 1ns / 1ps

module tb_sleep_controller ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_sleep_controller.vcd");
    $dumpvars(0, tb_sleep_controller);
    #1;
  end

  // Wire up the inputs and outputs:
  reg rst_n;
  reg clk;
  reg [1:0] energy_indicator;
  reg [1:0] stress_indicator;

  wire asleep;
  wire fell_asleep;
  wire en_inc;
  wire en_dec;
  
  // Instantiate sleep_controller module
  sleep_controller dut_sleep_controller (
      .clk (clk),   
      .rst_n (rst_n), 
      .energy_indicator (energy_indicator), 
      .stress_indicator (stress_indicator), 
      .asleep (asleep),
      .fell_asleep (fell_asleep),
      .en_inc (en_inc),
      .en_dec (en_dec)
  );

endmodule