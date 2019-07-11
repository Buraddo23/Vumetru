`timescale 1ns/1ns

module vga(pixel_clock, reset, data, h_sync, v_sync, red, green, blue);
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
    input [7:0] data;
    output h_sync, v_sync;
    output [2:0] red, green;
    output [1:0] blue;   
    
    reg h_sync_ff, h_sync_nxt, v_sync_ff, v_sync_nxt;
    reg [2:0] red_ff, red_nxt, green_ff, green_nxt;
    reg [1:0] blue_ff, blue_nxt;
    reg [C_SIZE:0] h_counter_ff, h_counter_nxt, v_counter_ff, v_counter_nxt;
    
    reg [15:0] address_ff, address_nxt;
    wire [3:0] color_data;
    
    reg [7:0] palette [0:15];
    reg [7:0] color;
    
    initial begin
        $readmemh("taunu_palette2.mem", palette);
    end

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
        address_nxt   = address_ff;
        
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
            address_nxt = h_counter_ff + v_counter_ff * 121 + 2;
        end
        
        if (v_counter_ff == TVBD + TVADDR + TVBD + TVFP + TVS + TVBP) begin
            v_counter_nxt = 'b0;
        end
        
        if ((h_counter_ff >= THBD) && (h_counter_ff < THBD + THADDR) && (v_counter_ff >= TVBD) && (v_counter_ff < TVBD + TVADDR)) begin
            //At display area
            red_nxt   = 3'b0;
            green_nxt = 3'b0;
            blue_nxt  = 2'b0;
            
            if ((h_counter_ff > 200) && (h_counter_ff <= 321) && (v_counter_ff < 174)) begin
                //Picture
                color     = palette[color_data];
                red_nxt   = color[7:5];
                green_nxt = color[4:2];
                blue_nxt  = color[1:0];
            end
            
            if ((v_counter_ff > 240) && (v_counter_ff < 260) && (h_counter_ff > 150) && (h_counter_ff < 490)) begin
                //Hands
                red_nxt   = 3'b111;
                green_nxt = 3'b111;
                blue_nxt  = 2'b11;
            end
            
            if ((v_counter_ff > 240) && (v_counter_ff < 440) && (h_counter_ff > 280) && (h_counter_ff < 300)) begin
                //Left leg
                red_nxt   = 3'b111;
                green_nxt = 3'b111;
                blue_nxt  = 2'b11;
            end
            
            if ((v_counter_ff > 240) && (v_counter_ff < 440) && (h_counter_ff > 360) && (h_counter_ff < 380)) begin
                //Left leg
                red_nxt   = 3'b111;
                green_nxt = 3'b111;
                blue_nxt  = 2'b11;
            end   

            if ((h_counter_ff - 320) * (h_counter_ff - 320) + (v_counter_ff - 280) * (v_counter_ff - 280) < (50 + data * data)) begin
                //Circle
                red_nxt   = 3'b0;
                green_nxt = 3'b100;
                blue_nxt  = 2'b0;
            end
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
            address_ff   <= 16'b0;
        end
        else begin
            h_sync_ff    <= h_sync_nxt;
            v_sync_ff    <= v_sync_nxt;
            red_ff       <= red_nxt;
            green_ff     <= green_nxt;
            blue_ff      <= blue_nxt;
            h_counter_ff <= h_counter_nxt;
            v_counter_ff <= v_counter_nxt;
            address_ff   <= address_nxt;
        end
    end
    
    rom 
        #(
            .SIZE(3),
            .FILE("taunu.mem")
        ) rom
        (
            .clk(pixel_clock),
            .address(address_ff), 
            .data(color_data)
        );
endmodule