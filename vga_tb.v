`timescale 1ns/1ns

module vga_tb;
    reg tb_clk, tb_reset;
    wire tb_h_sync, tb_v_sync;
    wire [2:0] tb_red, tb_green;
    wire [1:0] tb_blue;
    
    initial begin
        tb_clk = 1'b1;
        forever begin
            #1 tb_clk = !tb_clk;
        end
    end
    
    initial begin
        tb_reset = 1'b1;
        #3 tb_reset = 1'b0;
    end
    
    vga 
        #(
            .thaddr(4),
            .thfp(1),
            .ths(3),
            .thbp(2),
            .thbd(1),
            .tvaddr(4),
            .tvfp(1),
            .tvs(3),
            .tvbp(2),
            .tvbd(1),
            .h_pol(0),
            .v_pol(0),
            .c_size(4)
        ) DUT(
            .pixel_clock(tb_clk), 
            .reset(tb_reset),
            .h_sync(tb_h_sync), 
            .v_sync(tb_v_sync), 
            .red(tb_red), 
            .green(tb_green), 
            .blue(tb_blue)
        );
endmodule