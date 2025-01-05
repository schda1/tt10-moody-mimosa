`default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

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
    `ifdef PY_SIM
    , output wire [6:0]  dbg_cortisol
    , output wire [6:0]  dbg_dopamine
    , output wire [6:0]  dbg_gaba
    , output wire [6:0]  dbg_norepinephrine
    , output wire [6:0]  dbg_serotonin
    , output wire [15:0] dbg_stimuli
    , output wire [9:0]  dbg_neurotransmitter_level
    , output wire [7:0]  dbg_emotional_state
    , output wire [7:0]  dbg_action
    , output wire [1:0]  dbg_heartbeat
    , output wire [7:0]  dbg_nourishment
    , output wire [7:0]  dbg_vital_energy
    , output wire [8:0]  dbg_illness
    , output wire [9:0]  dbg_dev_stage_level
    `endif
);

    wire start, done;
    wire [15:0] address;
    wire [5:0] num_bytes;
    wire [1:0] development_stage;

    assign num_bytes = 6'b011000;

    wire wake_up_signal, sleep_in_signal;
    wire clk_model, hungry, starving, vital_energy_zero, ill;
    wire [15:0] stimuli;
    wire [7:0] emotional_state;
    wire [7:0] action;
    wire [1:0] heartbeat;
    wire [1:0] vital_energy_level;

    assign stimuli[0] = ui_in[0];   /* Tickle      */
    assign stimuli[1] = ui_in[1];   /* Play with   */
    assign stimuli[2] = ui_in[2];   /* Talk to     */
    assign stimuli[3] = ui_in[3];   /* Calm down   */
    assign stimuli[4] = ui_in[4];   /* Feed        */
    assign stimuli[5] = ui_in[5];   /* Env: Cool   */
    assign stimuli[6] = ui_in[6];   /* Env: Hot    */
    assign stimuli[7] = ui_in[7];   /* Env: Quiet  */
    assign stimuli[8] = uio_in[0];  /* Env: Loud   */
    assign stimuli[9] = 0;          /* uio_in[1];  /* Env: Dark   */
    assign stimuli[10] = uio_in[1]; /* Env: Bright */
    assign stimuli[11] = hungry;
    assign stimuli[12] = starving;
    assign stimuli[13] = (vital_energy_level == 2'b00);
    assign stimuli[14] = ill;
    assign stimuli[15] = 0;

    wire spi_miso, spi_mosi, spi_sck, spi_cs, uart_tx;

    assign spi_miso = uio_in[2];
    assign uio_out[3] = spi_sck;
    assign uio_out[4] = spi_cs;
    assign uio_out[5] = spi_mosi;
    assign uio_out[6] = uart_tx;
    assign uio_out[7] = clk_model;

    assign uio_out[2:0] = 3'b0;
    assign uio_oe = 8'b1111_1000;

    wire [9:0] neurotransmitter_level_in;
    reg [9:0] neurotransmitter_level_feedback;
    wire [9:0] neurotransmitter_level_out;

    always @(posedge clk_model or negedge rst_n) begin
        if (!rst_n)
            neurotransmitter_level_feedback <= 10'b0;
        else
            neurotransmitter_level_feedback <= neurotransmitter_level_out;
    end

    assign neurotransmitter_level_in = neurotransmitter_level_feedback;

    // dynamic_clock_divider #(.N(2)) heartbeat_divider (
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .x(heartbeat),
    //     .clk_out(clk_model)
    // );

    static_clock_divider #(.N(14)) heartbeat_divider (
        .clk(clk),
        .rst_n(rst_n),
        .clk_out(clk_model)
    );

    nt_neurotransmitter_system neurotransmitter (
        .clk (clk_model),
        .rst_n (rst_n),
        .emotional_state (emotional_state),
        .development_stage (development_stage),
        .stimuli (stimuli),
        .action (action),
        .neurotransmitter_level_in (neurotransmitter_level_in),
        .neurotransmitter_level_out (neurotransmitter_level_out)
        `ifdef PY_SIM
        , .dbg_cortisol(dbg_cortisol)
        , .dbg_dopamine(dbg_dopamine)
        , .dbg_gaba(dbg_gaba)
        , .dbg_norepinephrine(dbg_norepinephrine)
        , .dbg_serotonin(dbg_serotonin)
        `endif
    );

    emotion_regulator emotions (
        .action (action),
        .neurotransmitter_level (neurotransmitter_level_out),
        .development_stage (development_stage),
        .stimuli (stimuli),
        .emotional_state (emotional_state)
    );

    vital_energy_system vital_energy_sys (
        .clk (clk_model),
        .rst_n (rst_n),
        .neurotransmitter_level (neurotransmitter_level_out),
        .stimuli (stimuli),
        .action (action),
        .vital_energy_level (vital_energy_level),
        .vital_energy_zero (vital_energy_zero)
         `ifdef PY_SIM
        , .dbg_vital_energy(dbg_vital_energy)
        `endif
    );

    nourishment_system nourishment (
        .clk (clk_model),
        .rst_n (rst_n),
        .stimuli (stimuli),
        .action (action),
        .hungry (hungry),
        .starving (starving)
        `ifdef PY_SIM
        , .dbg_nourishment (dbg_nourishment)
        `endif
    );

    heartbeat_regulator heartbeat_ (
        .action (action),
        .neurotransmitter_level (neurotransmitter_level_out),
        .stimuli (stimuli),
        .emotional_state (emotional_state),
        .heartbeat (heartbeat)
    );

    sleep_regulator sleep_reg (
        .neurotransmitter_level (neurotransmitter_level_out),
        .stimuli (stimuli),
        .action (action),
        .vital_energy_level (vital_energy_level),
        .vital_energy_zero (vital_energy_zero),
        .wake_up_signal (wake_up_signal),
        .sleep_in_signal (sleep_in_signal)
    );

    action_regulator actions (
        .clk (clk_model),
        .rst_n (rst_n),
        .stimuli (stimuli),
        .emotional_state(emotional_state),
        .development_stage (development_stage),
        .vital_energy_level (vital_energy_level),
        .sleep_in_signal (sleep_in_signal),
        .wake_up_signal (wake_up_signal),
        .action (action)
    );

    illness_system illness_sys (
        .clk (clk_model),
        .rst_n (rst_n),
        .stimuli (stimuli),
        .action (action),
        .neurotransmitter_level (neurotransmitter_level_out),
        .ill (ill)
        `ifdef PY_SIM
        , .dbg_illness (dbg_illness)
        `endif
    );

    development_stage_system development_stage_sys (
        .clk (clk_model),
        .rst_n (rst_n),
        .stimuli (stimuli),
        .emotional_state (emotional_state),
        .action (action),
        .development_stage (development_stage)
        `ifdef PY_SIM
        , .dbg_dev_stage_level (dbg_dev_stage_level)
        `endif
    );

    

    counter_with_pulse #(.TARGET_COUNT(10)) counter_ (
        .clk (clk_model),
        .rst_n (rst_n),
        .pulse (start)
    );

    /* The clock is the start signal as only the start signal
     * indicates that a new phrase is to be spoken */
    speech_planner speech_planner_ (
        .clk (start), 
        .nrst (rst_n),
        .emotional_state (emotional_state),
        .development_stage (development_stage),
        .action (action),
        .address (address)
    );

    remember_and_talk talking (
        .clk (clk),
        .rst_n (rst_n),
        .start(start), 
        .address(address),
        .num_bytes(num_bytes),
        .spi_miso(spi_miso),
        .spi_mosi(spi_mosi),
        .spi_clk(spi_sck),
        .spi_cs(spi_cs),
        .uart_tx(uart_tx),
        .done(done)
    );

    `ifdef PY_SIM
    assign dbg_stimuli = stimuli;
    assign dbg_neurotransmitter_level = neurotransmitter_level_out;
    assign dbg_emotional_state = emotional_state;
    assign dbg_action = action;
    assign dbg_heartbeat = heartbeat;
    `endif

    assign uo_out = action;

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

    // `ifdef PY_SIM
    // assign dbg_energy = energy;
    // assign dbg_stress = stress;
    // assign dbg_pleasure = pleasure;
    // `endif

endmodule