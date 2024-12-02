`default_nettype none
`timescale 1ns / 1ps

module tb_heartbeat_model ();

  // Dump the signals to a VCD file
  initial begin
    $dumpfile("tb_heartbeat_model.vcd");
    $dumpvars(0, tb_heartbeat_model);
    #1;
  end

  // Wire up the inputs and outputs:
  reg [7:0] emotion;
  reg sleeping;
  wire [1:0] heartbeat;

  // Instantiate heartbeat_model classifier module 
  heartbeat_model dut (
      .emotion (emotion),   
      .sleeping (sleeping),
      .heartbeat (heartbeat)
  );

endmodule
