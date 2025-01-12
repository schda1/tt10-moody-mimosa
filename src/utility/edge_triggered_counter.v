module edge_triggered_counter (
    input wire clk,
    input wire rst_n,
    input wire ext_in,
    output reg [3:0] counter
);

    reg ext_in_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 4'b0000;
            ext_in_d <= 0;
        end else begin
            ext_in_d <= ext_in;
            if (ext_in && !ext_in_d) begin
                counter <= counter + 1;
            end
        end
    end

endmodule