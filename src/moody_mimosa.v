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
    wire [1:0] stress_indicator;
    wire setval;
    wire asleep;
    wire fell_asleep;
    wire en_inc;
    wire en_dec;

    assign stress_indicator = 0;
    assign setval  = 0;

    sleep_controller sleep_ctrl (
        .clk(ui_in[0]),
        .rst_n(rst_n),
        .energy_indicator(energy_indicator), 
        .stress_indicator(stress_indicator), 
        .asleep(asleep), 
        .fell_asleep(fell_asleep),
        .en_inc(en_inc),
        .en_dec(en_dec)
    );

    saturating_counter #(.N(7), .SET_VAL(64)) energy_cnt (
        .clk(ui_in[0]),
        .rst_n(rst_n), 
        .inc(en_inc),
        .dec(en_dec),
        .setval(setval), 
        .value(energy)
    );

    range_classifier #(.N(7)) energy_classifier (
        .number(energy), 
        .out_bits(energy_indicator)
    );
    
    // Output assignments
    assign uo_out = {asleep, energy};
    assign uio_out = {2'b00, asleep, fell_asleep, en_inc, en_dec, energy_indicator};                // Unused outputs set to 0
    assign uio_oe  = 0;                // Unused, all set to input (inactive)

endmodule