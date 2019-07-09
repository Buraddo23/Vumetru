`timescale 1ns/1ns

module vga_tb;
    reg tb_clk, tb_reset;
    reg [7:0] tb_data;
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
        tb_data  = 8'hFF;
        #5 tb_reset = 1'b0;
    end
    
    vga
        #(
            .THADDR(4),
            .THFP(1),
            .THS(3),
            .THBP(2),
            .THBD(0),
            .TVADDR(4),
            .TVFP(1),
            .TVS(3),
            .TVBP(2),
            .TVBD(0),
            .H_POL(0),
            .V_POL(0),
            .C_SIZE(4)
        ) DUT(
            .pixel_clock(tb_clk), 
            .reset(tb_reset),
            .data(tb_data),
            .h_sync(tb_h_sync), 
            .v_sync(tb_v_sync), 
            .red(tb_red), 
            .green(tb_green), 
            .blue(tb_blue)
        );
endmodule