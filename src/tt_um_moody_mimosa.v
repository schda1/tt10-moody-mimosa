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
    , output wire [6:0] dbg_acetylcholine      
    , output wire [6:0] dbg_cortisol
    , output wire [6:0] dbg_dopamine
    , output wire [6:0] dbg_gaba
    , output wire [6:0] dbg_glutamate
    , output wire [6:0] dbg_insulin
    , output wire [6:0] dbg_norepinephrine
    , output wire [6:0] dbg_serotonin
    , output wire [15:0] dbg_stimuli
    , output wire [15:0] dbg_neurotransmitter_level
    , output wire [7:0]  dbg_emotional_state 
    , output wire [7:0]  dbg_action
    , output wire [1:0]  dbg_sleep_state
    , output wire [1:0]  dbg_heartbeat
    , output wire [6:0]  dbg_nourishment
    , output wire [6:0]  dbg_vital_energy
    `endif
);

    assign uio_oe = 8'b1111_1100;

    wire clk_model;
    wire hungry;
    wire overfed;
    wire [15:0] stimuli;
    wire [7:0] emotional_state;
    wire [7:0] action;
    wire [1:0] sleep_state;
    wire [1:0] heartbeat;
    wire [1:0] vital_energy_level;

    assign stimuli[0] = ui_in[1];   /* Tickle      */
    assign stimuli[1] = ui_in[2];   /* Play with   */
    assign stimuli[2] = ui_in[3];   /* Talk to     */
    assign stimuli[3] = ui_in[4];   /* Calm down   */
    assign stimuli[4] = ui_in[5];   /* Feed        */
    assign stimuli[5] = ui_in[6];   /* Env: Cool   */
    assign stimuli[6] = ui_in[7];   /* Env: Hot    */
    assign stimuli[7] = uio_in[0];  /* Env: Quiet  */
    assign stimuli[8] = uio_in[1];  /* Env: Loud   */
    assign stimuli[9] = uio_in[2];  /* Env: Dark   */
    assign stimuli[10] = uio_in[3]; /* Env: Bright */
    assign stimuli[11] = hungry;
    assign stimuli[12] = overfed;
    assign stimuli[13] = (vital_energy_level == 2'b00);
    assign stimuli[14] = 0;
    assign stimuli[15] = 0;

    assign uo_out = emotional_state;

    assign uio_out[1:0] = 2'b00;
    assign uio_out[2] = clk_model;
    assign uio_out[7:3] = 5'b00000;

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
        .clk(clk), 
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
        `ifdef PY_VERILATOR
        , .dbg_acetylcholine(dbg_acetylcholine) 
        , .dbg_cortisol(dbg_cortisol)
        , .dbg_dopamine(dbg_dopamine)
        , .dbg_gaba(dbg_gaba)
        , .dbg_glutamate(dbg_glutamate)
        , .dbg_insulin(dbg_insulin)
        , .dbg_norepinephrine(dbg_norepinephrine)
        , .dbg_serotonin(dbg_serotonin)
        `endif
    );

    emotion_regulator emotions (
        .sleep_state (sleep_state), 
        .neurotransmitter_level (neurotransmitter_level_out), 
        .emotional_state (emotional_state)
    );

    vital_energy_system vital_energy_sys (
        .clk (clk_model),
        .rst_n (rst_n),
        .neurotransmitter_level (neurotransmitter_level_out),
        .stimuli (stimuli), 
        .action (action), 
        .sleep_state (sleep_state), 
        .vital_energy_level (vital_energy_level)
         `ifdef PY_VERILATOR
        , .dbg_vital_energy(dbg_vital_energy) 
        `endif
    );

    sleep_controller sleep_ctrl (
        .clk (clk_model),
        .rst_n (rst_n),
        .neurotransmitter_level (neurotransmitter_level_out),
        .stimuli (stimuli), 
        .action (action), 
        .vital_energy_level (vital_energy_level),
        .sleep_state (sleep_state)
    );

    action_regulator actions (
        .stimuli (stimuli),
        .emotional_state(emotional_state),
        .sleep_state(sleep_state),
        .action(action)
    );

    nourishment_system nourishment (
        .clk (clk_model),
        .rst_n (rst_n),
        .sleep_state (sleep_state),
        .stimuli (stimuli),
        .action (action),
        .hungry (hungry),
        .overfed (overfed)
        `ifdef PY_VERILATOR
        , .dbg_nourishment (dbg_nourishment)
        `endif
    );

    heartbeat_regulator heartbeat_ (
        .sleep_state (sleep_state),
        .neurotransmitter_level (neurotransmitter_level_out),
        .stimuli (stimuli), 
        .emotional_state (emotional_state),
        .heartbeat (heartbeat)
    );

    wire _unused = &{ena, clk, rst_n, ui_in[0], uio_in[7:4], 1'b0};

    `ifdef PY_VERILATOR
    assign dbg_stimuli = stimuli;
    assign dbg_neurotransmitter_level = neurotransmitter_level_out;
    assign dbg_emotional_state = emotional_state; 
    assign dbg_action = action;
    assign dbg_heartbeat = heartbeat;
    assign dbg_sleep_state = sleep_state;
    `endif

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