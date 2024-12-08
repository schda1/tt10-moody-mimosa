module tt_um_moody_mimosa (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // Always 1 when the design is powered
    input  wire       clk,      // Clock
    input  wire       rst_n     // Active-low reset
    `ifdef FPGA_TARGET
    , output wire [7:0] debug   // Additional debug port for FPGA
    `endif
);

    localparam AWAKE   = 2'b00, 
               ASLEEP  = 2'b01,
               DYING   = 2'b10, 
               DEAD    = 2'b11;


    // List all unused inputs to prevent warnings
    wire _unused = &{ena, clk, 1'b0};

    wire [6:0] energy;
    wire [1:0] energy_indicator;
    wire energy_inc;
    wire energy_dec;

    wire [6:0] stress;
    wire [1:0] stress_indicator;
    wire stress_inc;
    wire stress_dec;

    wire [6:0] pleasure;
    wire [1:0] pleasure_indicator; 
    wire pleasure_inc;
    wire pleasure_dec;
 
    wire setval;
    wire fell_asleep;
    wire state_ctrl_en_inc;
    wire state_ctrl_en_dec;
    wire state_ctrl_st_inc;
    wire state_ctrl_st_dec;
    wire state_ctrl_pl_inc;
    wire state_ctrl_pl_dec;

    wire dead; 
    wire clk_model;
    wire [1:0] heartbeat;

    wire [1:0] state;

    wire [7:0] emotion;
    
    assign setval  = 0;
    assign state_ctrl_pl_dec = 0;
    assign state_ctrl_st_inc = 0;

    assign dead = (energy == 7'b0000000) ? 1'b1 : 1'b0;

    dynamic_clock_divider #(.N(2)) heartbeat_divider (
        .clk(ui_in[0]), 
        .rst_n(rst_n),
        .x(heartbeat),
        .clk_out(clk_model)
    );

    physical_state_controller state_ctrl (
        .clk(clk_model),
        .rst_n(rst_n),
        .energy_indicator(energy_indicator), 
        .stress_indicator(stress_indicator), 
        .dead(dead),
        .state_out(state), 
        .fell_asleep(fell_asleep),
        .en_inc(state_ctrl_en_inc),
        .en_dec(state_ctrl_en_dec),
        .st_dec(state_ctrl_st_dec),
        .pl_inc(state_ctrl_pl_inc)
    );
    
    energy_regulator energy_reg (
        .state_controller_inc(state_ctrl_en_inc),
        .state_controller_dec(state_ctrl_en_dec),
        .energy_inc(energy_inc),
        .energy_dec(energy_dec)
    );  

    saturating_counter #(.N(7), .SET_VAL(64), .DEFAULT_VAL(96)) energy_counter (
        .clk(clk_model),
        .rst_n(rst_n), 
        .inc(energy_inc),
        .dec(energy_dec),
        .setval(setval), 
        .value(energy)
    );

    range_classifier #(.N(7)) energy_classifier (
        .number(energy), 
        .out_bits(energy_indicator)
    );

    stress_regulator stress_regul (
        .state_controller_inc(state_ctrl_st_inc),
        .state_controller_dec(state_ctrl_st_dec),
        .stimuli(ui_in[7:1]),
        .stress_inc(stress_inc),
        .stress_dec(stress_dec)
    );  

    saturating_counter #(.N(7), .SET_VAL(64), .DEFAULT_VAL(0)) stress_counter (
        .clk(clk_model),
        .rst_n(rst_n), 
        .inc(stress_inc),
        .dec(stress_dec),
        .setval(setval), 
        .value(stress)
    );

    range_classifier #(.N(7)) stress_classifier (
        .number(stress), 
        .out_bits(stress_indicator)
    );

    pleasure_regulator pleasure_regul (
        .state_controller_inc(state_ctrl_pl_inc),
        .state_controller_dec(state_ctrl_pl_dec),
        .stimuli(ui_in[7:1]),
        .pleasure_inc(pleasure_inc),
        .pleasure_dec(pleasure_dec)
    );  

    saturating_counter #(.N(7), .SET_VAL(64), .DEFAULT_VAL(64)) pleasure_counter (
        .clk(clk_model),
        .rst_n(rst_n), 
        .inc(pleasure_inc),
        .dec(pleasure_dec),
        .setval(setval), 
        .value(pleasure)
    );

    range_classifier #(.N(7)) pleasure_classifier (
        .number(pleasure), 
        .out_bits(pleasure_indicator)
    );

    emotional_model emotions (
        .energy(energy_indicator),
        .stress(stress_indicator), 
        .pleasure(pleasure_indicator),
        .physical_state(state), 
        .emotion(emotion)
    );

    heartbeat_model heartbeat_model_inst (
        .emotion(emotion),
        .state(state), 
        .heartbeat(heartbeat)
    );

    // Final assignments
    assign uo_out = emotion;
    assign uio_oe = 8'b1111_1111; 
    assign uio_out[0] = (state == DEAD) ? 1'b0 : (state == ASLEEP);
    assign uio_out[1] = (state == DEAD) ? 1'b0 : (state == DYING);
    assign uio_out[2] = (state == DEAD) ? 1'b0 : clk_model;

    // Debug assignments 
    assign uio_out[3] = (state == DEAD) ? 1'b0 : ui_in[0];
    assign uio_out[4] = (state == DEAD) ? 1'b0 : stress_inc;
    assign uio_out[5] = (state == DEAD) ? 1'b0 : stress_dec;
    assign uio_out[7:6] = (state == DEAD) ? 2'b00 : ui_in[2:1];    

    `ifdef FPGA_TARGET
    // assign debug = energy;
    assign debug = {2'b00, pleasure_indicator, stress_indicator, energy_indicator};
    `endif    

endmodule