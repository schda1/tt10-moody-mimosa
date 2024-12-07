`default_nettype none

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
    wire asleep;
    wire fell_asleep;
    wire sleep_ctrl_en_inc;
    wire sleep_ctrl_en_dec;
    wire sleep_ctrl_st_inc;
    wire sleep_ctrl_st_dec;
    wire sleep_ctrl_pl_inc;
    wire sleep_ctrl_pl_dec;

    wire clk_model;
    wire [1:0] heartbeat;

    wire [1:0] state;

    wire [7:0] emotion;
    
    assign setval  = 0;
    assign sleep_ctrl_pl_dec = 0;
    assign sleep_ctrl_st_inc = 0;


    dynamic_clock_divider #(.N(2)) heartbeat_divider (
        .clk(ui_in[0]), 
        .rst_n(rst_n),
        .x(heartbeat),
        .clk_out(clk_model)
    );

    sleep_controller sleep_ctrl (
        .clk(clk_model),
        .rst_n(rst_n),
        .energy_indicator(energy_indicator), 
        .stress_indicator(stress_indicator), 
        .asleep(asleep), 
        .fell_asleep(fell_asleep),
        .en_inc(sleep_ctrl_en_inc),
        .en_dec(sleep_ctrl_en_dec),
        .st_dec(sleep_ctrl_st_dec),
        .pl_inc(sleep_ctrl_pl_inc)
    );
    
    energy_regulator energy_reg (
        .sleep_controller_inc(sleep_ctrl_en_inc),
        .sleep_controller_dec(sleep_ctrl_en_dec),
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
        .sleep_controller_inc(sleep_ctrl_st_inc),
        .sleep_controller_dec(sleep_ctrl_st_dec),
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
        .sleep_controller_inc(sleep_ctrl_pl_inc),
        .sleep_controller_dec(sleep_ctrl_pl_dec),
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
        .asleep(asleep), 
        .heartbeat(heartbeat)
    );

    // Output assignments
    assign state[0] = ~asleep;
    assign state[1] = 0;

    assign uo_out = emotion;
    assign uio_out = {state, pleasure_indicator, stress_indicator, energy_indicator};              
    assign uio_oe  = 0; 

    `ifdef FPGA_TARGET
    // assign debug = energy;
    assign debug = {ui_in[0], 3'b0, stress_dec, stress_inc, ui_in[2:1]};
    `endif    

endmodule