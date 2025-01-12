`default_nettype none

module dynamic_clock_divider #(parameter N = 2)(
    input wire clk,
    input wire rst_n, 
    input wire [N-1:0] x,
    output reg clk_out
);

    reg [N-1:0] div_count;
    reg [N-1:0] x_sync;
    reg [N-1:0] x_sync_prev;

    /* Synchronize the x input to avoid glitches when it changes */
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            x_sync <= 0;
            x_sync_prev <= 0;
        end else begin
            x_sync_prev <= x_sync;
            x_sync <= x;
        end
    end

    /* Main clock divider logic */
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            div_count <= 0;
            clk_out <= 0;
        end else if (x_sync == 0) begin
            clk_out <= ~clk_out;
            div_count <= 0;
        end else if (x_sync == 1) begin
            if (div_count == 1) begin
                clk_out <= ~clk_out;
                div_count <= 0;
            end else begin
                div_count <= div_count + 1;
            end
        end else if (x_sync != x_sync_prev) begin
            div_count <= 0;
            clk_out <= 0;
        end else if (div_count == (x_sync)) begin
            clk_out <= ~clk_out;
            div_count <= 0;
        end else begin
            div_count <= div_count + 1;
        end
    end

endmodule