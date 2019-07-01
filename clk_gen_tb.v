`timescale 1ns/1ns

module clk_gen_tb;
    
    reg tb_clk_in, tb_enable, tb_reset;
    wire tb_clk_out;
    
    initial begin
        tb_clk_in = 1'b1;
        forever begin
            #1 tb_clk_in = !tb_clk_in;
        end
    end
    
    initial begin
        tb_enable = 1'b1;
        tb_reset  = 1'b1;
        #1 tb_reset  = 1'b0;
    end
    clk_gen DUT(.clk_in(tb_clk_in), .clk_out(tb_clk_out), .enable(tb_enable), .reset(tb_reset));
endmodule