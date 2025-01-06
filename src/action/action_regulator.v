`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

`default_nettype none

module action_regulator (
    input wire clk,
    input wire rst_n,
    input wire [15:0] stimuli,
    input wire [7:0] emotional_state,
    input wire [1:0] vital_energy_level,
    input wire [1:0] development_stage,
    input wire sleep_in_signal,
    input wire wake_up_signal,
    output reg [7:0] action
);

    /* Define states */
    localparam SLEEP      = 8'b00000001;
    localparam EAT        = 8'b00000010;
    localparam PLAY       = 8'b00000100;
    localparam SMILE      = 8'b00001000;
    localparam BABBLE     = 8'b00010000;
    localparam KICK_LEGS  = 8'b00100000;
    localparam IDLE       = 8'b01000000;
    localparam CRY        = 8'b10000000;

    localparam BABY     = 2'b00;
    localparam CHILD    = 2'b01;
    localparam TEENAGER = 2'b10;
    localparam ADULT    = 2'b11;

    reg [7:0] next_action;

    /* External stimuli */
    wire starving, tickle, play_with, talk_to, calm_down, feed, hungry, tired;
    assign tickle    = stimuli[0];
    assign play_with = stimuli[1];
    assign talk_to   = stimuli[2];
    assign calm_down = stimuli[3];
    assign feed      = stimuli[4];
    assign hungry    = stimuli[11];
    assign starving  = stimuli[12];
    assign tired     = stimuli[13];

    /* Sleep */
    wire is_asleep;
    assign is_asleep = action[0];

    /* Emotions */
    wire happy, excited, stressed, nervous, bored, angry, calm, apathetic;
    assign happy     = emotional_state[0];
    assign excited   = emotional_state[1];
    assign stressed  = emotional_state[2];
    assign nervous   = emotional_state[3];
    assign bored     = emotional_state[4];
    assign angry     = emotional_state[5];
    assign calm      = emotional_state[6];
    assign apathetic = emotional_state[7];

    /* Transition indicators */
    wire ready_to_eat, ready_to_cry, ready_to_smile, ready_to_stop_crying, ready_to_start_babble, ready_to_play, autonomous;

    assign autonomous = (development_stage == TEENAGER ) || (development_stage == ADULT);

    assign ready_to_eat = (happy || calm || angry || nervous || bored) && hungry && !action[1] && !is_asleep && (feed || autonomous);

    assign ready_to_play = (happy || calm || excited || bored) && !tired && !action[2] && !is_asleep && (play_with);

    assign ready_to_smile = ((tired && (bored || calm)) || (!tired && nervous)) && 
                            (talk_to || tickle || calm_down) && 
                            !action[3] && !is_asleep;

    assign ready_to_start_babble = (happy || calm || excited || bored) && !tired && 
                                   (talk_to || (tickle && (development_stage == BABY))) && !action[4] && !is_asleep;

    assign ready_to_cry = (stressed || starving || (tired && (nervous || bored || angry || hungry)) || 
                          (tired && (tickle || play_with || talk_to)) && (development_stage == BABY)) && 
                          !action[1] && !action[7] && !is_asleep;

    assign ready_to_stop_crying = !hungry && tired && calm_down && !is_asleep;
    

    /* Synchronous state transition */
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            action <= SMILE;
        end else begin
            action <= next_action;
        end
    end

    /* Asynchronous next state determination */
    always @* begin
       if (sleep_in_signal) begin
            next_action = SLEEP;
        end else if (wake_up_signal) begin
            next_action = IDLE;
        end else if (ready_to_eat) begin
            next_action = EAT;
        end else if (ready_to_start_babble) begin
            next_action = BABBLE;
        end else if (ready_to_play) begin
            next_action = PLAY;
        end else if (ready_to_cry) begin
            next_action = CRY;
        end else if (apathetic) begin
            next_action = IDLE;
        end else begin
            case (action)
                /* 0 SLEEP */
                SLEEP: begin
                    next_action = SLEEP;
                end
                /* 1 EAT */
                EAT: begin
                    if (vital_energy_level == 2'b11) begin
                        next_action = SMILE;
                    end else begin
                        next_action = EAT;
                    end
                end
                /* 2 PLAY */
                PLAY: begin
                    if ((development_stage == BABY) && (bored && !tired)) begin
                        next_action = SMILE;
                    end else if (tired) begin
                        next_action = IDLE;
                    end else begin
                        next_action = PLAY;
                    end
                end
                /* 3 SMILE */
                SMILE: begin
                    if ((tired || hungry) && (development_stage == BABY)) begin
                        next_action = KICK_LEGS;
                    end else begin
                        next_action = SMILE;
                    end
                end
                /* 4 BABBLE */
                BABBLE: begin
                    if ((tired || hungry) && (development_stage == BABY)) begin
                        next_action = KICK_LEGS;
                    end else begin
                        next_action = BABBLE;
                    end
                end
                /* 5 KICK_LEGS */
                KICK_LEGS: begin
                    next_action = KICK_LEGS;
                end
                /* 6 IDLE */
                IDLE: begin
                    next_action = IDLE;
                end
                /* 7 CRY */
                CRY: begin
                    if (ready_to_stop_crying) begin
                        next_action = IDLE;
                    end else begin
                        next_action = CRY;
                    end
                end

                default: begin
                    next_action = IDLE;
                end
            endcase
        end
    end

endmodule