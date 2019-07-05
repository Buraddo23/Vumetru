`timescale 1ns/1ns

module image_proc(reset, clock, disp_enable, row, column, red, green, blue);
    parameter C_SIZE = 9;
    
    input reset, clock, disp_enable;
    input [C_SIZE:0] row, column;
    output [2:0] red, green;
    output [1:0] blue;
    
    reg [2:0] red_ff, red_nxt, green_ff, green_nxt;
    reg [1:0] blue_ff, blue_nxt;
    
    assign red   = red_ff;
    assign green = green_ff;
    assign blue  = blue_ff;
    
    always @ (*) begin
        red_nxt   = red_ff;
        green_nxt = green_ff;
        blue_nxt  = blue_ff;
        
        if (disp_enable) begin
            //Display area
            red_nxt   = 3'b111;
            green_nxt = 3'b111;
            blue_nxt  = 2'b0;
        end
        else begin
            //Sync period (set to ground)
            red_nxt   = 3'b0;
            green_nxt = 3'b0;
            blue_nxt  = 2'b0;
        end
    end
    
    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            red_ff   <= 3'b0;
            green_ff <= 3'b0;
            blue_ff  <= 2'b0;
        end
        else begin
            red_ff   <= red_nxt;
            green_ff <= green_nxt;
            blue_ff  <= blue_ff;
        end        
    end
    
endmodule