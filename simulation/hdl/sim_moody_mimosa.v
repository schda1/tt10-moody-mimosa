module sim_moody_mimosa (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n,
    output wire [6:0] dbg_energy,
    output wire [6:0] dbg_stress,
    output wire [6:0] dbg_pleasure,
    output wire [6:0] dbg_nourishment
);

    wire [7:0] ui_in_model;
    wire clk_prescaled;

    // // Create model clock, 100 MHz prescaled by 2**24 (6 Hz)
    // static_clock_divider #(.N(2)) model_clk_divider (
    //     .clk(clk),                  
    //     .rst_n(rst_n),                
    //     .clk_out(clk_prescaled)     
    // );

    assign ui_in_model = { ui_in[7:1], clk};

    // Instantiate the actual moody mimosa module
    tt_um_moody_mimosa mimosa (
        .ui_in(ui_in_model),              
        .uo_out(uo_out),         
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n),
        .dbg_energy(dbg_energy),
        .dbg_stress(dbg_stress),
        .dbg_pleasure(dbg_pleasure),
        .dbg_nourishment(dbg_nourishment)
    );

endmodule