`timescale 1ns/1ns

module top_clk_gen(clk_board, enable, reset, clk_out_uart, clk_out_vga);
    parameter board_freq = 50000000,
              baud_rate  =     9600,
              uart_freq  = baud_rate*16,
              vga_freq   = 25175000;              

    input clk_board, enable, reset;
    output clk_out_uart, clk_out_vga;
    
    clk_gen 
        #(
            .in_freq(board_freq), 
            .out_freq(uart_freq)
        ) clk_gen_uart
        (
            .clk_in(clk_board), 
            .clk_out(clk_out_uart), 
            .enable(enable), 
            .reset(reset)
        );
        
    clk_gen
        #(
            .in_freq(board_freq),
            .out_freq(vga_freq)
        ) clk_gen_vga
        (
            .clk_in(clk_board),
            .clk_out(clk_out_vga),
            .enable(enable),
            .reset(reset)
        );
endmodule