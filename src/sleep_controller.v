module sleep_controller (
    input wire clk,
    input wire rst_n,
    input wire [1:0] energy_indicator,
    input wire [1:0] stress_indicator,
    output reg asleep,
    output reg fell_asleep,
    output reg en_inc,
    output reg en_dec
);

    // State encoding
    localparam AWAKE = 1'b0, ASLEEP = 1'b1;
    reg state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= AWAKE;
            asleep <= 1'b0;
            fell_asleep <= 1'b0;
            en_inc <= 1'b0;
            en_dec <= 1'b0;
        end else begin
            fell_asleep <= 1'b0;

            case (state)
                AWAKE: begin
                    asleep <= 1'b0;
                    en_inc <= 1'b0;
                    en_dec <= 1'b1;

                    if (energy_indicator[1] == 0 && !stress_indicator[1]) begin
                        state <= ASLEEP;
                        fell_asleep <= 1'b1;
                    end
                end

                ASLEEP: begin
                    asleep <= 1'b1;
                    en_inc <= 1'b1;
                    en_dec <= 1'b0;

                    if (energy_indicator == 2'b11 || stress_indicator[1] == 1) begin
                        state <= AWAKE;
                    end
                end
            endcase
        end
    end

endmodule