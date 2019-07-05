`timescale 1ns/1ns

module vga_controller(pixel_clock, reset, h_sync, v_sync, disp_enable, row, column);
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
    output h_sync, v_sync, disp_enable;
    output [C_SIZE:0] row, column;

    reg h_sync_ff, h_sync_nxt, v_sync_ff, v_sync_nxt, de_ff, de_nxt;
    reg [C_SIZE:0] h_counter_ff, h_counter_nxt, v_counter_ff, v_counter_nxt;

    assign h_sync      = h_sync_ff;
    assign v_sync      = v_sync_ff;
    assign row         = v_counter_ff;
    assign column      = h_counter_ff - 1'b1;
    assign disp_enable = de_ff;

    always @ (*) begin
        h_sync_nxt    = h_sync_ff;
        v_sync_nxt    = v_sync_ff;
        h_counter_nxt = h_counter_ff;
        v_counter_nxt = v_counter_ff;
        de_nxt        = de_ff;
        
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
        
        if ((h_counter_ff >= THBD) && (h_counter_ff < THBD + THADDR) && (v_counter_ff >= TVBD) && (v_counter_ff < TVBD + TVADDR)) begin
            //At display area
            de_nxt = 1'b1;
        end
        else begin
            //Outside display area (sync period)
            de_nxt = 1'b0;
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
            de_nxt = 1'b1;
        end
    end

    always @ (posedge pixel_clock or posedge reset) begin
        if (reset) begin
            h_sync_ff    <= 1'b0;
            v_sync_ff    <= 1'b0;
            h_counter_ff <=  'b0;
            v_counter_ff <=  'b0;
            de_ff        <= 1'b0;
        end
        else begin
            h_sync_ff    <= h_sync_nxt;
            v_sync_ff    <= v_sync_nxt;
            h_counter_ff <= h_counter_nxt;
            v_counter_ff <= v_counter_nxt;
            de_ff        <= de_nxt;
        end
    end
endmodule