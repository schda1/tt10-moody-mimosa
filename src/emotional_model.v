`default_nettype none

module emotional_model (
    input wire [1:0] energy,         // 2-bit input for energy (x[0], x[1])
    input wire [1:0] stress,         // 2-bit input for stress (x[2], x[3])
    input wire [1:0] pleasure,       // 2-bit input for pleasure (x[4], x[5])
    input wire [1:0] physical_state, // 2-bit input describing the physical state
    output wire [7:0] emotion        // 8-bit output for emotion
);

    wire awake;
    wire [1:0] en_shifted;
    wire [1:0] st_shifted;
    wire [1:0] pl_shifted;

    // Only emotions during sleep
    assign awake = (~physical_state[0] & ~physical_state[1]);

    // Simplication: Only use 3 not 4 key values (LOW=0, OK=1,2, HIGH=3)
    assign en_shifted[1] = energy[1] & energy[0];
    assign en_shifted[0] = energy[1] ^ energy[0];
    assign st_shifted[1] = stress[1] & stress[0];
    assign st_shifted[0] = stress[1] ^ stress[0];
    assign pl_shifted[1] = pleasure[1] & pleasure[0];
    assign pl_shifted[0] = pleasure[1] ^ pleasure[0];

    // Combine the three 2-bit signals into a 6-bit variable x
    wire [5:0] x = {en_shifted, st_shifted, pl_shifted};

    // Logic for the emotion output (derived with pyeda and espresso)
    assign emotion[7] = awake & (( x[1] &  x[3] &  x[5]) | (x[0] & x[3]));
    assign emotion[6] = awake & ( ~x[1] &  x[2] &  x[5]);
    assign emotion[5] = awake & ( ~x[0] & ~x[1] &  x[3]);
    assign emotion[4] = awake & ( ~x[3] & ~x[4] & ~x[5]);
    assign emotion[3] = awake & ((~x[0] & ~x[1] & ~x[2] & ~x[3] & x[5]) | 
                                 (~x[0] & ~x[1] & ~x[3] &  x[4]       ));
    assign emotion[2] = awake & (( x[1] & ~x[3] &  x[5]               ) | 
                                 ( x[1] &  x[3] & ~x[5]               ) | 
                                 ( x[0] & ~x[2] & ~x[3] &  x[5]       ));
    assign emotion[1] = awake & (  x[0] & ~x[3] &  x[4]);
    assign emotion[0] = awake & (  x[1] & ~x[3] &  x[4]);

endmodule