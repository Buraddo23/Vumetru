`timescale 1ns/1ns

module uart_tb;
    parameter delay = 32;
    
    reg tb_rx, tb_clk, tb_clk_16, tb_reset;
    wire [7:0] tb_data;
    wire tb_load;
    wire tb_error;
    
    initial begin
        tb_clk = 1'b1;
        forever begin
            #16 tb_clk = !tb_clk;
        end
    end
    initial begin
        tb_clk_16 = 1'b1;
        forever begin
            #1 tb_clk_16 = !tb_clk_16;
        end
    end
    
    initial begin
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
    uart DUT(.rx(tb_rx), .clk(tb_clk), .clkx16(tb_clk_16), .reset(tb_reset), .data(tb_data), .load(tb_load), .error(tb_error));
endmodule