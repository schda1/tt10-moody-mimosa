`default_nettype none

module heartbeat_model (
    input [7:0] emotion,    // 8-bit input for encoded emotion
    input asleep,           // 1-bit input indicating sleep state
    output [1:0] heartbeat  // 2-bit output for encoded heartbeat
);

    // Heartbeat = 3:       Sleeping, any emotion
    // Heartbeat = 2:       Bored (Bit-3), Tired (Bit-4)
    // Heartbeat = 1:       Happy (Bit-0), Comfortable (Bit-1)
    // Heartbeat = 0:       Excited (Bit-3), Angry (Bit-5), Nervous (Bit-6), Stressed (Bit-7)

    // Output logic for heartbeat bits
    assign heartbeat[1] = asleep | emotion[3] | emotion[4]; 
    assign heartbeat[0] = asleep | emotion[0] | emotion[1];                  

endmodule