`timescale 1ns/1ns

module top_clk_gen(clk_board, enable, reset, clk_out_uart, clk_out_vga);
    parameter BOARD_FREQ = 100000000,
              BAUD_RATE  =      9600,
              VGA_FREQ   =  25000000;
              
    localparam UART_FREQ  = BAUD_RATE*16;              

    input clk_board, enable, reset;
    output clk_out_uart, clk_out_vga;
    
    clk_gen 
        #(
            .IN_FREQ(BOARD_FREQ), 
            .OUT_FREQ(UART_FREQ),
            .BIT_SIZE(13)
        ) clk_gen_uart
        (
            .clk_in(clk_board), 
            .clk_out(clk_out_uart), 
            .enable(enable), 
            .reset(reset)
        );
        
    clk_gen
        #(
            .IN_FREQ(BOARD_FREQ),
            .OUT_FREQ(VGA_FREQ),
            .BIT_SIZE(1)
        ) clk_gen_vga
        (
            .clk_in(clk_board),
            .clk_out(clk_out_vga),
            .enable(enable),
            .reset(reset)
        );
endmodule