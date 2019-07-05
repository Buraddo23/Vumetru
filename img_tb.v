`timescale 1ns/1ns

module img_tb;
    reg tb_clk, tb_reset;
    wire tb_h_sync, tb_v_sync, tb_de;
    wire [4:0] tb_row, tb_column;
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
        #5 tb_reset = 1'b0;
    end
    
    vga_controller
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
        ) VGA (
            .pixel_clock(tb_clk), 
            .reset(tb_reset),
            .h_sync(tb_h_sync), 
            .v_sync(tb_v_sync), 
            .disp_enable(tb_de), 
            .row(tb_row), 
            .column(tb_column)
        );
        
    image_proc
        #(
            .C_SIZE(4)
        ) DUT (
            .reset(tb_reset), 
            .clock(tb_clk), 
            .disp_enable(tb_de), 
            .row(tb_row), 
            .column(tb_column), 
            .red(tb_red), 
            .green(tb_green), 
            .blue(tb_blue)
        );
endmodule