`default_nettype none

module sleep_controller (
    input wire clk,
    input wire rst_n,
    input wire [15:0] neurotransmitter_level,
    input wire [15:0] stimuli,
    input wire [7:0] action,
    input wire [1:0] vital_energy_level,
    output reg [1:0] sleep_state
);

    localparam AWAKE = 2'b01;
    localparam ASLEEP = 2'b00;

    wire [1:0] NE, CORT, ACH, DOP, GABA, GLUT, INS, SER;
    wire hungry;
    wire tickle, play_with, talk_to, calm_down;
    wire hot, loud, bright;

    /* Neurotransmitter levels */
    assign ACH  = neurotransmitter_level[1:0];
    assign CORT = neurotransmitter_level[3:2];
    assign DOP  = neurotransmitter_level[5:4];
    assign GABA = neurotransmitter_level[7:6];
    assign GLUT = neurotransmitter_level[9:8];
    assign INS  = neurotransmitter_level[11:10];
    assign NE   = neurotransmitter_level[13:12];
    assign SER  = neurotransmitter_level[15:14];

    /* Stimuli */
    assign tickle = stimuli[0];
    assign play_with = stimuli[1];
    assign talk_to = stimuli[2];
    assign calm_down = stimuli[3];
    assign hot = stimuli[6];
    assign loud = stimuli[8];
    assign bright = stimuli[10];
    assign hungry = stimuli[11];

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sleep_state <= AWAKE;  
        end 
        else 
        begin
            case (sleep_state)
                AWAKE: begin
                    /* Sleep in */
                    if ((vital_energy_level == 2'b00) && 
                        (NE   == 2'b00 || NE   == 2'b01 ) &&
                        (CORT == 2'b00 || CORT == 2'b01 ) &&
                        (~tickle && ~play_with && ~talk_to && ~hot && ~bright && ~loud && ~hungry)
                        ) 
                    begin
                        sleep_state <= ASLEEP;
                    end
                end
                ASLEEP: begin
                    /* Wake up */
                    if ((vital_energy_level == 2'b11) || 
                        (NE   == 2'b10 || NE   == 2'b11 ) &&
                        (CORT == 2'b10 || CORT == 2'b11 ) &&
                        (tickle || play_with || talk_to || hot || bright || loud || hungry)
                        )
                    begin
                        sleep_state <= AWAKE;
                    end
                end
                default: sleep_state <= AWAKE; 
            endcase
        end
    end

endmodule
