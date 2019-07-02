`timescale 1ns/1ns

module top(rx, clk_board, enable, reset, data);
    parameter board_freq = 50000000,
              baud_rate = 9600;

    input rx, clk_board, enable, reset;
    output [7:0] data, red, green, blue;
    output h_sync, v_sync;
    
    wire [7:0] data_uart;
    wire clk_uart, load, clk_vga;
    
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
            .enable(enable), 
            .reset(reset), 
            .clk_out_uart(clk_uart), 
            .clk_out_vga(clk_vga)
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
        
    vga vga_module
        (
            .pixel_clock(clk_vga), 
            .reset(reset), 
            .h_sync(h_sync), 
            .v_sync(v_sync), 
            .red(red), 
            .green(green), 
            .blue(blue)
        );
endmodule