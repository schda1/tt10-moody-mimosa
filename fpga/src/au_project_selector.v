module au_project_selector #(
    parameter PROJECT_NUMBER = 17
)(
    input wire sel_rst_n,
    input wire sel_inc,
    input wire sel_ena,
    output reg ena
);
    reg [$clog2(PROJECT_NUMBER):0] counter;

    always @(posedge sel_inc or negedge sel_rst_n) begin
        if (!sel_rst_n) begin
            counter <= 0;
            ena <= 0;
        end else if (sel_ena && counter == PROJECT_NUMBER) begin
            ena <= 1;
        end else begin
            ena <= 0;
            if (counter < PROJECT_NUMBER) begin
                counter <= counter + 1;
            end
        end
    end

endmodule