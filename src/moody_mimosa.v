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

    assign setval  = 0;

    sleep_controller sleep_ctrl (
        .clk(ui_in[0]),
        .rst_n(rst_n),
        .energy_indicator(energy_indicator), 
        .stress_indicator(stress_indicator), 
        .asleep(asleep), 
        .fell_asleep(fell_asleep),
        .en_inc(energy_inc),
        .en_dec(energy_dec)
    );

    saturating_counter #(.N(7), .SET_VAL(64)) energy_counter (
        .clk(ui_in[0]),
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

    saturating_counter #(.N(7), .SET_VAL(64)) stress_counter (
        .clk(ui_in[0]),
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

    saturating_counter #(.N(7), .SET_VAL(64)) pleasure_counter (
        .clk(ui_in[0]),
        .rst_n(rst_n), 
        .inc(pleasure_inc),
        .dec(pleasure_dec),
        .setval(setval), 
        .value(pleasure)
    );

    range_classifier #(.N(7)) pleasure_classifier (
        .number(pleasure), 
        .out_bits(pleasure_classifier)
    );
    
    // Output assignments
    assign uo_out = {asleep, energy};
    assign uio_out = 0;                // Unused outputs set to 0
    assign uio_oe  = 0;                // Unused, all set to input (inactive)

endmodule