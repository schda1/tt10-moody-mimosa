`default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

module counter_with_pulse #(
    parameter TARGET_COUNT = 255 // Default value up to which the counter counts
)(
    input wire clk,
    input wire rst_n,
    output wire pulse
);
    reg [$clog2(TARGET_COUNT+1)-1:0] count;

    /* When target count is reached, a single-clock pulse is emitted */
    assign pulse = (count == TARGET_COUNT - 1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end else begin
            if (count == TARGET_COUNT) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule
