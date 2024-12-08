module physical_state_controller (
    input wire clk,
    input wire rst_n,
    input wire [1:0] energy_indicator,
    input wire [1:0] stress_indicator,
    input wire dead, 
    output reg [1:0] state_out,
    output reg fell_asleep,       
    output reg en_inc,
    output reg en_dec,
    output reg st_dec, 
    output reg pl_inc 
);

    localparam AWAKE   = 2'b00, 
               ASLEEP  = 2'b01,
               DYING   = 2'b10, 
               DEAD    = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    // State transition
    always @(*) begin
        next_state = state;
        fell_asleep = 0;
        en_inc = 0;
        en_dec = 0;
        st_dec = 0;
        pl_inc = 0;

        case (state)
            AWAKE: begin
                en_inc = 0;
                en_dec = 1;
                st_dec = 0;
                pl_inc = 0;
                if (energy_indicator == 2'b00) begin
                    next_state = DYING; 
                end else if (energy_indicator == 2'b01 && !stress_indicator[1]) begin
                    next_state = ASLEEP;
                    fell_asleep = 1;
                end
            end

            ASLEEP: begin
                en_inc = 1;
                en_dec = 0;
                st_dec = 1;
                pl_inc = 1;
                if (energy_indicator == 2'b00) begin
                    next_state = DYING; 
                end else if (energy_indicator == 2'b11 || stress_indicator[1] == 1) begin
                    next_state = AWAKE;
                end
            end

            DYING: begin
                en_inc = 0;
                en_dec = 1;
                st_dec = 0;
                pl_inc = 0;
                if (energy_indicator != 2'b00) begin
                    next_state = AWAKE; 
                end else if (dead) begin
                    next_state = DEAD;
                end
            end

            DEAD: begin
                en_inc = 0;
                en_dec = 0;
                st_dec = 0;
                pl_inc = 0;
            end

            default: begin
                next_state = AWAKE;
            end
        endcase
    end

    // Sequential logic: State update on clock edge or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= AWAKE;
            state_out <= AWAKE;
        end else begin
            state <= next_state;
            state_out <= next_state;
        end
    end

endmodule
