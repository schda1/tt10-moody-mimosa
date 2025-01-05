`default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off CASEOVERLAP */
`endif

module speech_planner (
    input wire clk,
    input wire nrst,
    input wire [7:0] emotional_state, 
    input wire [7:0] action,
    input wire [1:0] development_stage,
    output reg [15:0] address
);

    reg variant_bit;
    wire [2:0] special_bits;

    assign special_bits[0] = action[1]; /* Eating */
    assign special_bits[1] = action[2]; /* Playing */
    assign special_bits[2] = action[7]; /* Crying */

    always @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            variant_bit <= 1'b0;
        end else begin
            variant_bit <= ~variant_bit;
        end
    end
    
    always @(*) begin
        if (!nrst) begin
            address = 16'b0;
        end else begin

            /* First 5 bits are always 0 (phrases are 32-byte aligned) */
            address[4:0] = 5'b00000;

            /* There are two different phrases for each scenario */
            address[5] = variant_bit;

            /* Decode emotion from 8-bit to 3-bit */
            casez (emotional_state)
                8'b???????1: address[8:6] = 3'd0;
                8'b??????1?: address[8:6] = 3'd1;
                8'b?????1??: address[8:6] = 3'd2;
                8'b????1???: address[8:6] = 3'd3;
                8'b???1????: address[8:6] = 3'd4;
                8'b??1?????: address[8:6] = 3'd5;
                8'b?1??????: address[8:6] = 3'd6;
                8'b1???????: address[8:6] = 3'd7;
                default: address[8:6] = 3'd0;
            endcase

            /* Only certain actions contribute the choice of speech */
            casez (special_bits)
                3'b??1: address[10:9] = 2'd1;
                3'b?1?: address[10:9] = 2'd2;
                3'b1??: address[10:9] = 2'd3;
                default: address[10:9] = 2'd0;
            endcase

            /* Development stage, already encoded */
            address[12:11] = development_stage;

            /* 16-bit address is needed but upper 3 bits are 0 */
            address[15:13] = 3'b0;

        end
    end

endmodule
