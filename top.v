`timescale 1ns/1ns

module top(rx, clk_board, enable, reset, data);
    parameter board_freq = 50000000,
              baud_rate = 9600;

    input rx, clk_board, enable, reset;
    output [7:0] data;
    
    wire [7:0] data_uart;
    wire clk_uart, load;
    
    data_bistabil ff
        (
            .clock(clk_uart), 
            .enable(enable), 
            .reset(reset), 
            .data_in(data_uart), 
            .load(load), 
            .error(error), 
            .data_out(data)
        );
    top_clk_gen 
        #(
            .board_freq(board_freq), 
            .baud_rate(baud_rate)
        ) clk_gen_module
        (
            .clk_board(clk_board), 
            .clk_out_uart(clk_uart), 
            .enable(enable), 
            .reset(reset)
        );
    uart uart_module
        (
            .rx(rx), 
            .clkx16(clk_uart), 
            .reset(reset), 
            .data(data_uart), 
            .load(load), 
            .error(error)
        );
endmodule