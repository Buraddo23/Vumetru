`timescale 1ns/1ns

module top_tb;
    parameter delay = 128;

    reg tb_rx, tb_clk_board, tb_enable, tb_reset;
    wire tb_h_sync, tb_v_sync;
    wire [2:0] tb_red, tb_green;
    wire [1:0] tb_blue;
    
    initial begin
        tb_clk_board = 1'b1;
        forever begin
            #1 tb_clk_board = !tb_clk_board;
        end
    end
    
    initial begin
        tb_enable = 1'b1;
        tb_rx = 1'b1;
        tb_reset = 1'b1;
        #(2*delay) tb_reset = 1'b0;
        #(4*delay) tb_rx = 1'b0; //start bit
        #delay tb_rx = 1'b1; //bit 7
        #delay tb_rx = 1'b0; //bit 6
        #delay tb_rx = 1'b1; //bit 5
        #delay tb_rx = 1'b0; //bit 4
        #delay tb_rx = 1'b1; //bit 3
        #delay tb_rx = 1'b0; //bit 2
        #delay tb_rx = 1'b1; //bit 1
        #delay tb_rx = 1'b0; //bit 0
        #delay tb_rx = 1'b1; //final bit
        
        #(4*delay) tb_rx = 1'b0; //start bit
        #delay tb_rx = 1'b0; //bit 7
        #delay tb_rx = 1'b1; //bit 6
        #delay tb_rx = 1'b0; //bit 5
        #delay tb_rx = 1'b1; //bit 4
        #delay tb_rx = 1'b0; //bit 3
        #delay tb_rx = 1'b1; //bit 2
        #delay tb_rx = 1'b0; //bit 1
        #delay tb_rx = 1'b1; //bit 0
        #delay tb_rx = 1'b1; //final bit
        
        #(4*delay) tb_rx = 1'b0; //start bit
        #delay tb_rx = 1'b1; //bit 7
        #delay tb_rx = 1'b0; //bit 6
        #delay tb_rx = 1'b1; //bit 5
        #delay tb_rx = 1'b0; //bit 4
        #delay tb_rx = 1'b1; //bit 3
        #delay tb_rx = 1'b0; //bit 2
        #delay tb_rx = 1'b1; //bit 1
        #delay tb_rx = 1'b0; //bit 0
        #delay tb_rx = 1'b0;
        #(5*delay) tb_rx = 1'b1;
    end
    
    top 
        #(
            .BOARD_FREQ(64), 
            .BAUD_RATE(1),
            .VGA_FREQ(16)
        ) DUT(
            .rx(tb_rx), 
            .clk_board(tb_clk_board), 
            .enable(tb_enable), 
            .reset(tb_reset),
            .h_sync(tb_h_sync), 
            .v_sync(tb_v_sync), 
            .red(tb_red), 
            .green(tb_green), 
            .blue(tb_blue)
        );
endmodule