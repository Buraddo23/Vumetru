`timescale 1ns/1ns

module top_tb;
    parameter delay = 128;

    reg tb_rx, tb_clk_board, tb_enable, tb_reset;
    wire [7:0] tb_data;
    //wire tb_load, tb_error;
    
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
        #(5*delay)
        $finish;
    end
    top #(.board_freq(64), .baud_rate(1)) DUT(.rx(tb_rx), .clk_board(tb_clk_board), .enable(tb_enable), .reset(tb_reset), .data(tb_data));//, .load(tb_load), .error(tb_error));
endmodule