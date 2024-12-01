`default_nettype none

module emotional_model (
    input [1:0] energy,    // 2-bit input for energy (x[0], x[1])
    input [1:0] stress,    // 2-bit input for stress (x[2], x[3])
    input [1:0] pleasure,  // 2-bit input for pleasure (x[4], x[5])
    output [7:0] emotion   // 8-bit output for emotion
);

    // Combine the three 2-bit signals into a 6-bit variable x
    wire [5:0] x = {energy, stress, pleasure};

    // Logic for the emotion output (derived with pyeda and espresso)
    assign emotion[7] = (x[1] & x[3] & x[5]) | (x[0] & x[3]);
    assign emotion[6] = (~x[1] & x[2] & x[5]);
    assign emotion[5] = (~x[0] & ~x[1] & x[3]);
    assign emotion[4] = (~x[3] & ~x[4] & ~x[5]);
    assign emotion[3] = ((~x[0] & ~x[1] & ~x[2] & ~x[3] & x[5]) | 
                         (~x[0] & ~x[1] & ~x[3] & x[4]));
    assign emotion[2] = ((x[1] & ~x[3] & x[5]) | 
                         (x[1] & x[3] & ~x[5]) | 
                         (x[0] & ~x[2] & ~x[3] & x[5]));
    assign emotion[1] = (x[0] & ~x[3] & x[4]);
    assign emotion[0] = (x[1] & ~x[3] & x[4]);

endmodule