`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif
`default_nettype none

module sleep_controller (
    input wire clk,
    input wire rst_n,
    input wire wake_up_signal,
    input wire sleep_in_signal,
    output reg sleep_state
);

    localparam AWAKE = 1'b1;
    localparam ASLEEP = 1'b0;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sleep_state <= AWAKE;  
        end 
        else 
        begin
            case (sleep_state)
                AWAKE: begin
                    if (sleep_in_signal) begin
                        sleep_state <= ASLEEP;
                    end
                end
                ASLEEP: begin
                    if (wake_up_signal) begin
                        sleep_state <= AWAKE;
                    end
                end
            endcase
        end
    end

endmodule
