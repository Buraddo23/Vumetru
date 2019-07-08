`timescale 1ns/1ns

module vga(pixel_clock, reset, h_sync, v_sync, red, green, blue);
    parameter THADDR = 640, //H addresable video length
              THFP   =  16, //H front porch
              THS    =  96, //H sync time 
              THBP   =  48, //H back porch
              THBD   =   0, //H left/right border
              TVADDR = 480, //V addresable bideo length
              TVFP   =  10, //V front porch
              TVS    =   2, //V sync time
              TVBP   =  33, //V back porch
              TVBD   =   0, //V top/bottom border
              H_POL  =   0, //0 - negative polarity (sync on 0), 1 - positive polarity (sync on 1)
              V_POL  =   0, //0 - neg, 1 - pos
              C_SIZE =   9; //Counter no of bits
    
    input pixel_clock, reset;
    output h_sync, v_sync;
    output [2:0] red, green;
    output [1:0] blue;

    reg h_sync_ff, h_sync_nxt, v_sync_ff, v_sync_nxt;
    reg [2:0] red_ff, red_nxt, green_ff, green_nxt;
    reg [1:0] blue_ff, blue_nxt;
    reg [C_SIZE:0] h_counter_ff, h_counter_nxt, v_counter_ff, v_counter_nxt;

    assign h_sync = h_sync_ff;
    assign v_sync = v_sync_ff;
    assign red    = red_ff;
    assign green  = green_ff;
    assign blue = blue_ff;

    always @ (*) begin
        h_sync_nxt    = h_sync_ff;
        v_sync_nxt    = v_sync_ff;
        red_nxt       = red_ff;
        green_nxt     = green_ff;
        blue_nxt      = blue_ff;
        h_counter_nxt = h_counter_ff;
        v_counter_nxt = v_counter_ff;
        
        //Horizontal sync
        if ((h_counter_ff >= THBD + THADDR + THBD + THFP) && (h_counter_ff < THBD + THADDR + THBD + THFP + THS)) begin
            h_sync_nxt = H_POL;
        end
        else begin
            h_sync_nxt = !H_POL;
        end
        
        //Vertical sync
        if ((v_counter_ff >= TVBD + TVADDR + TVBD + TVFP) && (v_counter_ff < TVBD + TVADDR + TVBD + TVFP + TVS)) begin
            v_sync_nxt = V_POL;
        end
        else begin
            v_sync_nxt = !V_POL;
        end

        //Counters update
        if (h_counter_ff == THBD + THADDR + THBD + THFP + THS + THBP - 1) begin
            h_counter_nxt = 'b0;
            v_counter_nxt = v_counter_ff + 1'b1;
        end
        else begin
            h_counter_nxt = h_counter_ff + 1'b1;
        end
        
        if (v_counter_ff == TVBD + TVADDR + TVBD + TVFP + TVS + TVBP) begin
            v_counter_nxt = 'b0;
        end
        
        if ((h_counter_ff >= THBD) && (h_counter_ff < THBD + THADDR) && (v_counter_ff >= TVBD) && (v_counter_ff < TVBD + TVADDR)) begin
            //At display area
            red_nxt   = 3'b111;
            green_nxt = 3'b111;
            blue_nxt  = 2'b11;
        end
        else begin
            //Outside display area (sync period)
            red_nxt   = 3'b0;
            green_nxt = 3'b0;
            blue_nxt  = 2'b0;
        end
    end

    always @ (posedge pixel_clock or posedge reset) begin
        if (reset) begin
            h_sync_ff    <= 1'b0;
            v_sync_ff    <= 1'b0;
            red_ff       <= 3'b0;
            green_ff     <= 3'b0;
            blue_ff      <= 2'b0;
            h_counter_ff <=  'b0;
            v_counter_ff <=  'b0;
        end
        else begin
            h_sync_ff    <= h_sync_nxt;
            v_sync_ff    <= v_sync_nxt;
            red_ff       <= red_nxt;
            green_ff     <= green_nxt;
            blue_ff      <= blue_nxt;
            h_counter_ff <= h_counter_nxt;
            v_counter_ff <= v_counter_nxt;
        end
    end
endmodule