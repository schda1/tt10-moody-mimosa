module au_moody_mimosa (
    input  clk,             /* Main clock                          */
    input  rst_n,           /* Active-low reset                    */
    input  sel_rst_n,       /* Project selection emulation, rst    */
    input  sel_inc,         /* Project selection emulation, inc    */
    input  sel_ena,         /* Project selection emulation, ena    */
    output  model_ena,      /* Model enable                        */  
    output [7:0] port_a0,   /* Input pins                          */
    input  [7:0] port_a1,   /* Output pins                         */
    inout  [7:0] port_a2,   /* Bidirectional pins                  */
    input  usb_rx,          /* UART rx signal (from on-board FTDI) */
    output usb_tx           /* UART tx signal (to on-board FTDI)   */
);
    /* Handle the bidirectional pins */
    wire [7:0] uio_oe;
    wire [7:0] uio_out;
    wire [7:0] uio_in;

    wire [7:0] debug_out;
    wire model_clk, model_rst_n;

    /* Emulate project selection */
    au_project_selector #(
        .PROJECT_NUMBER(17)
    ) project_selector (
        .sel_rst_n(sel_rst_n),
        .sel_inc(sel_inc),
        .sel_ena(sel_ena),
        .ena(model_ena)
    );

    /* Make sure than in- and outputs are only routed when project is enabled */
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : uio_mapping
            assign uio_in[i] = model_ena ? port_a2[i] : 1'bz;
            assign port_a2[i] = (uio_oe[i] && model_ena) ? uio_out[i] : 1'bz;
        end
    endgenerate

    assign model_clk = model_ena ? clk : 1'b0;
    assign model_rst_n = model_ena ? rst_n : 1'b0;

    /* Instantiate the actual moody mimosa module */
    tt_um_moody_mimosa mimosa (
        .uo_out(port_a0),
        .ui_in(port_a1),
        .uio_out(uio_out),
        .uio_in(uio_in),
        .uio_oe(uio_oe),
        .debug(debug_out),
        .ena(model_ena),
        .clk(model_clk),
        .rst_n(model_rst_n)
    );

    /* The alchitry UART has an on-board FTDI. Route the UART TX accordingly */
    assign usb_tx = port_a2[6];

endmodule