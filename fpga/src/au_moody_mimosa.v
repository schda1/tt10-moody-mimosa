module au_moody_mimosa (
    output [7:0] port_a0,   /* Input pins         */
    input  [7:0] port_a1,   /* Output pins        */
    inout  [7:0] port_a2,   /* Bidirectional pins */
    input  clk,             /* Main clock         */
    input  rst_n,           /* Active-low reset   */
    input  usb_rx,          /* UART rx signal (from on-board FTDI) */
    output usb_tx           /* UART tx signal (to on-board FTDI)   */
);
    wire [7:0] debug_out;
    wire ena, clk_mimosa;
    wire clk_prescaled;

    /* Handle the bidirectional pins */
    wire [7:0] uio_oe;
    wire [7:0] uio_out;
    wire [7:0] uio_in;

    assign uio_in = port_a2;
    assign port_a2[0] = uio_oe[0] ? uio_out[0] : 1'bz;
    assign port_a2[1] = uio_oe[1] ? uio_out[1] : 1'bz;
    assign port_a2[2] = uio_oe[2] ? uio_out[2] : 1'bz;
    assign port_a2[3] = uio_oe[3] ? uio_out[3] : 1'bz;
    assign port_a2[4] = uio_oe[4] ? uio_out[4] : 1'bz;
    assign port_a2[5] = uio_oe[5] ? uio_out[5] : 1'bz;
    assign port_a2[6] = uio_oe[6] ? uio_out[6] : 1'bz;
    assign port_a2[7] = uio_oe[7] ? uio_out[7] : 1'bz;

    /* The alchitry UART has an on-board FTDI. Route the UART TX accordingly */
    assign usb_tx = port_a2[6];

    /* Instantiate the actual moody mimosa module */
    tt_um_moody_mimosa mimosa (
        .uo_out(port_a0),
        .ui_in(port_a1),
        .uio_out(uio_out),
        .uio_in(uio_in),
        .uio_oe(uio_oe),
        .debug(debug_out),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    assign ena = 1'b1;

endmodule