module prescaler #(parameter DIV_FACTOR = 4) (
    input wire clk,
    input wire rst_n,
    output reg clk_out
);

    localparam HALF_DIV = DIV_FACTOR >> 1;

    reg [$clog2(HALF_DIV)+1:0] div_counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_counter <= 0;
            clk_out <= 0;
        end else begin
            if (div_counter == HALF_DIV - 1) begin
                div_counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                div_counter <= div_counter + 1;
            end
        end
    end

endmodule