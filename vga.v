`timescale 1ns/1ns

module vga(pixel_clock, reset, h_sync, v_sync, red, green, blue);
    parameter thaddr = 640, //H addresable video length
              thfp   =  16, //H front porch
              ths    =  96, //H sync time 
              thbp   =  48, //H back porch
              thbd   =   0, //H left/right border
              tvaddr = 480, //V addresable bideo length
              tvfp   =  10, //V front porch
              tvs    =   2, //V sync time
              tvbp   =  33, //V back porch
              tvbd   =   0, //V top/bottom border
              h_pol  =   0, //0 - negative polarity (sync on 0), 1 - positive polarity (sync on 1)
              v_pol  =   0; //0 - neg, 1 - pos
    
    input pixel_clock, reset;
    output h_sync, v_sync;
    output [7:0] red, green, blue;

    reg h_sync_ff, h_sync_nxt, v_sync_ff, v_sync_nxt;
    reg [7:0] red_ff, red_nxt, green_ff, green_nxt, blue_ff, blue_nxt;
    reg [9:0] h_counter_ff, h_counter_nxt, v_counter_ff, v_counter_nxt;

    assign h_sync = h_sync_ff;
    assign v_sync = v_sync_ff;
    assign red    = red_ff;
    assign green  = green_ff;
    assign blue   = blue_ff;

    always @ (*) begin
        h_sync_nxt    = h_sync_ff;
        v_sync_nxt    = v_sync_ff;
        red_nxt       = red_ff;
        green_nxt     = green_ff;
        blue_nxt      = blue_ff;
        h_counter_nxt = h_counter_ff;
        v_counter_nxt = v_counter_ff;
        
        //Horizontal sync
        if (h_counter_ff <= thfp) begin
            //Front porch
            h_sync_nxt = !h_pol;
            red_nxt    = 8'b0;
            green_nxt  = 8'b0;
            blue_nxt   = 8'b0;
        end
        else if (h_counter_ff <= thfp + ths) begin
            //Sync
            h_sync_nxt = h_pol;
            red_nxt    = 8'b0;
            green_nxt  = 8'b0;
            blue_nxt   = 8'b0;
        end
        else if (h_counter_ff <= thfp + ths + thbp) begin
            //Back porch
            h_sync_nxt = !h_pol;
            red_nxt    = 8'b0;
            green_nxt  = 8'b0;
            blue_nxt   = 8'b0;
        end
        else if (h_counter_ff <= thfp + ths + thbp + thbd) begin
            //Border region (black bg)
            h_sync_nxt = !h_pol;
            red_nxt    = 8'b0;
            green_nxt  = 8'b0;
            blue_nxt   = 8'b0;
        end
        else if (h_counter_ff <= thfp + ths + thbp + thbd + thaddr) begin
            //Active pixels (set rgb values as needed, H_pos = h_counter-thfp-ths-thbp-thbd
            h_sync_nxt = !h_pol;
        end
        else begin
            h_counter_nxt = 10'b0;
            v_counter_nxt = v_counter_ff + 10'b1;
        end
        
        //Vertical sync
        if (v_counter_ff <= tvfp) begin
            //Front porch
            v_sync_nxt = !v_pol;
            red_nxt    = 8'b0;
            green_nxt  = 8'b0;
            blue_nxt   = 8'b0;
        end
        else if (v_counter_ff <= tvfp + tvs) begin
            //Sync
            v_sync_nxt = v_pol;
            red_nxt    = 8'b0;
            green_nxt  = 8'b0;
            blue_nxt   = 8'b0;
        end
        else if (v_counter_ff <= tvfp + tvs + tvbp) begin
            //Back porch
            v_sync_nxt = !v_pol;
            red_nxt    = 8'b0;
            green_nxt  = 8'b0;
            blue_nxt   = 8'b0;
        end
        else if (v_counter_ff <= tvfp + tvs + tvbp + tvbd) begin
            //Border region (black bg)
            v_sync_nxt = !v_pol;
            red_nxt    = 8'b0;
            green_nxt  = 8'b0;
            blue_nxt   = 8'b0;
        end
        else if (v_counter_ff <= tvfp + tvs + tvbp + tvbd + tvaddr) begin
            //Active pixels (set rgb values as needed, V_pos = v_counter-tvfp-tvs-tvbp-tvbd
            v_sync_nxt = !v_pol;
        end
        else begin
            v_counter_nxt = 10'b0;
        end
        
        //At display area
        if ((h_counter_ff <= thfp + ths + thbp + thbd + thaddr) && (v_counter_ff <= tvfp + tvs + tvbp + tvbd + tvaddr)) begin
            red_nxt   = 8'hff;
            green_nxt = 8'hff;
            blue_nxt  = 8'h00;
        end
        
        h_counter_nxt = h_counter_ff + 10'b1;
    end

    always @ (posedge pixel_clock or posedge reset) begin
        if (reset) begin
            h_sync_ff    <= !h_pol;
            v_sync_ff    <= !v_pol;
            red_ff       <= 8'b0;
            green_ff     <= 8'b0;
            blue_ff      <= 8'b0;
            h_counter_ff <= 10'b0;
            v_counter_ff <= 10'b0;
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