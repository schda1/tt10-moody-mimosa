 `default_nettype none
`ifndef PY_SIM
/* verilator lint_off UNUSEDSIGNAL */
`endif

/* 
 * Data is read from the SPI FRAM and sent via UART  
 * 
 * | SPI TX | SPI TX    | SPI TX    | SPI RX |         | ... | SPI RX |
 * | OpCode | Address 1 | Address 0 | Data 0 |         | ... | Data N |
 *                                           |         |     |        |
 *                                           | UART TX |     |        | UART TX | UART TX |
 *                                           | Data 0  |     |        | Data N  | \n      |
 */

module remember_and_talk (
    input wire clk,             /* System clock                       */
    input wire rst_n,           /* Active-low reset                   */
    input wire start,           /* Start signal                       */
    input wire [15:0] address,  /* 16-bit SPI FRAM address            */
    input wire [5:0] num_bytes, /* Number of bytes to read (up to 62) */
    input wire spi_miso,        /* FRAM SPI MISO signal               */
    output wire spi_clk,        /* FRAM SPI Clock signal              */
    output wire spi_mosi,       /* FRAM SPI MOSI signal               */
    output wire spi_cs,         /* FRAM SPI Chip Select (active low)  */
    output wire uart_tx,        /* UART Transmit signal               */
    output reg done             /* Done signal                        */
);
 
    /* State definitions */
    parameter IDLE = 0, SPI_INIT = 1, SPI_RECV = 2, UART_SEND = 3, PREPARE_NEXT_BYTE = 4, SEND_NEWLINE = 5, DONE = 6;

    reg [2:0] state = IDLE;

    /* SPI registers */
    reg [7:0] spi_shift_reg;
    reg [15:0] address_reg;
    reg [3:0] spi_bit_count;
    reg [5:0] byte_count;
    reg [1:0] skip_address_bytes;
    reg spi_clk_toggle;
 
    /* UART registers */
    reg [9:0] uart_shift_reg;
    reg [3:0] uart_bit_count;
    reg uart_active;

    /* SPI Clock, Chip Select, and MOSI */
    assign spi_clk = spi_clk_toggle;
    assign spi_cs = (state == IDLE); 
    assign spi_mosi = spi_shift_reg[7];

    /* UART output (default high) */
    assign uart_tx = uart_active ? uart_shift_reg[0] : 1'b1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            spi_shift_reg <= 0;
            spi_bit_count <= 0;
            address_reg <= 0;
            byte_count <= 0;
            skip_address_bytes <= 2;
            uart_shift_reg <= 10'b1111111111;
            uart_bit_count <= 0;
            uart_active <= 0;
            spi_clk_toggle <= 0;
            done <= 0;
        end else begin
            case (state)
                /* IDLE state: Wait for start signal */
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        address_reg <= address;
                        byte_count <= num_bytes;
                        skip_address_bytes <= 2;
                        spi_shift_reg <= 8'b00000011;
                        spi_bit_count <= 0;
                        state <= SPI_INIT;
                    end
                end

                /* SPI Init: Send OpCode and read address */
                SPI_INIT: begin
                    if (spi_bit_count < 8) begin
                        spi_clk_toggle <= ~spi_clk_toggle;
                        if (spi_clk_toggle) begin
                            spi_bit_count <= spi_bit_count + 1;
                            spi_shift_reg <= {spi_shift_reg[6:0], 1'b0};
                        end
                    end else if (address_reg != 0) begin
                        spi_bit_count <= 0;
                        spi_shift_reg <= address_reg[15:8];
                        address_reg <= {address_reg[7:0], 8'b0};
                    end else begin
                        spi_bit_count <= 0;
                        state <= SPI_RECV;
                    end
                end

                /* SPI Receive: Read a byte from SPI */ 
                SPI_RECV: begin
                    if (spi_bit_count < 8) begin
                        spi_clk_toggle <= ~spi_clk_toggle;
                        if (spi_clk_toggle) begin
                            spi_shift_reg <= {spi_shift_reg[6:0], spi_miso};
                            spi_bit_count <= spi_bit_count + 1;
                        end
                    end else begin
                        spi_bit_count <= 0;

                        /* Address bytes response is not sent via UART! */
                        if (skip_address_bytes > 0) begin
                            skip_address_bytes <= skip_address_bytes - 1;
                            byte_count <= byte_count + 1;
                            state <= PREPARE_NEXT_BYTE;
                        end else begin
                            uart_shift_reg <= {1'b1, spi_shift_reg, 1'b0};
                            uart_bit_count <= 0;
                            uart_active <= 1;
                            state <= UART_SEND;
                        end
                    end
                end

                /* UART Send: Transmit the byte read via SPI via UART, with start and stop bit */
                UART_SEND: begin
                    if (uart_active) begin
                        uart_shift_reg <= {1'b0, uart_shift_reg[9:1]};
                        uart_bit_count <= uart_bit_count + 1;

                        if (uart_bit_count == 9) begin
                            uart_active <= 0;
                            uart_bit_count <= 0;
                            state <= PREPARE_NEXT_BYTE;
                        end
                    end
                end

                /* Determine whether an additional byte should be read or if the transfer is complete */
                PREPARE_NEXT_BYTE: begin 
                    if (byte_count > 1) begin
                        byte_count <= byte_count - 1;
                        state <= SPI_RECV;
                    end else if (byte_count == 1) begin
                        byte_count <= 0;
                        uart_shift_reg <= {1'b1, 8'h0A, 1'b0};
                        uart_active <= 1;
                        state <= SEND_NEWLINE;
                    end else begin
                        state <= DONE;
                    end
                end

                /* Finish by sending a newline character */
                SEND_NEWLINE: begin
                    if (uart_active) begin
                        uart_shift_reg <= {1'b0, uart_shift_reg[9:1]};
                        uart_bit_count <= uart_bit_count + 1;

                        if (uart_bit_count == 9) begin
                            uart_active <= 0;
                            state <= DONE;
                        end
                        
                    end
                end

                /* Done state: Wait until start signal reset */
                DONE: begin
                    done <= 1;
                    if (!start) begin 
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
