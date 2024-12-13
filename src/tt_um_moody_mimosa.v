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
    `ifdef PY_VERILATOR
    , output wire [6:0] dbg_energy
    , output wire [6:0] dbg_stress
    , output wire [6:0] dbg_pleasure
    `endif
);

    assign uo_out = ui_in + uio_in;
    assign uio_out = 0;
    assign uio_oe = 0;

    wire clk_model;
    wire hungry;
    wire overfed;
    wire [15:0] stimuli;
    wire [7:0] emotional_state;
    wire [7:0] action;
    wire [1:0] sleep_state;
    wire [1:0] heartbeat;

    assign stimuli[15] = hungry;
    assign stimuli[14] = overfed;
    assign stimuli[13:0] = 0;

    wire [15:0] neurotransmitter_level_in;
    reg [15:0] neurotransmitter_level_feedback;
    wire [15:0] neurotransmitter_level_out;

    always @(posedge clk_model or negedge rst_n) begin
        if (!rst_n)
            neurotransmitter_level_feedback <= 16'b0; 
        else
            neurotransmitter_level_feedback <= neurotransmitter_level_out;
    end

    assign neurotransmitter_level_in = neurotransmitter_level_feedback;

    dynamic_clock_divider #(.N(2)) heartbeat_divider (
        .clk(ui_in[0]), 
        .rst_n(rst_n),
        .x(heartbeat),
        .clk_out(clk_model)
    );

    nt_neurotransmitter_system neurotransmitter (
        .clk (clk_model),
        .rst_n (rst_n),
        .emotional_state (emotional_state),
        .stimuli (stimuli),
        .action (action),
        .sleep_state (sleep_state),
        .neurotransmitter_level_in (neurotransmitter_level_in),
        .neurotransmitter_level_out (neurotransmitter_level_out)
    );

    emotion_regulator emotions (
        .sleep_state (sleep_state), 
        .neurotransmitter_level (neurotransmitter_level_out), 
        .emotional_state (emotional_state)
    );

    sleep_regulator sleep (
        .neurotransmitter_level (neurotransmitter_level_out), 
        .emotional_state (emotional_state),
        .sleep_state (sleep_state)
    );

    action_regulator actions (
        .stimuli (stimuli),
        .emotional_state(emotional_state),
        .sleep_state(sleep_state),
        .action(action)
    );

    nourishment_regulator nourishment (
        .sleep_state (sleep_state),
        .neurotransmitter_level (neurotransmitter_level_out),
        .stimuli (stimuli),
        .emotional_state (emotional_state),
        .heartbeat (heartbeat),
        .hungry (hungry),
        .overfed (overfed)
    );

    heartbeat_regulator heartbeat_ (
        .sleep_state (sleep_state),
        .neurotransmitter_level (),
        .stimuli (stimuli), 
        .emotional_state (emotional_state),
        .heartbeat (heartbeat)
    );

    wire _unused = &{ena, clk, rst_n, 1'b0};

    // // Final assignments
    // assign uo_out = emotion;
    // assign uio_oe = 8'b1111_1111; 
    // assign uio_out[0] = (state == DEAD) ? 1'b0 : (state == ASLEEP);
    // assign uio_out[1] = (state == DEAD) ? 1'b0 : (state == DYING);
    // assign uio_out[2] = (state == DEAD) ? 1'b0 : clk_model;

    // // Debug assignments 
    // assign uio_out[3] = (state == DEAD) ? 1'b0 : ui_in[0];
    // assign uio_out[4] = (state == DEAD) ? 1'b0 : stress_inc;
    // assign uio_out[5] = (state == DEAD) ? 1'b0 : stress_dec;
    // assign uio_out[7:6] = (state == DEAD) ? 2'b00 : ui_in[2:1];    

    // `ifdef FPGA_TARGET
    // // assign debug = energy;
    // assign debug = {2'b00, pleasure_indicator, stress_indicator, energy_indicator};
    // `endif    

    // `ifdef PY_VERILATOR
    // assign dbg_energy = energy;
    // assign dbg_stress = stress;
    // assign dbg_pleasure = pleasure;
    // `endif

endmodule