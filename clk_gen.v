`timescale 1ns/1ns

module clk_gen(clk_in, clk_out, enable, reset);
    parameter IN_FREQ = 100000000, 
              OUT_FREQ = 25000000,
              MAX_VALUE = IN_FREQ / OUT_FREQ,
//            BIT_SIZE = $clog2(MAX_VALUE);
              BIT_SIZE = 10;

    input clk_in, enable, reset;
    output clk_out;

    reg clk_out_ff, clk_out_nxt;
    //(* keep = "true" *) 
    reg [BIT_SIZE:0] counter_ff, counter_nxt;
    
    assign clk_out = clk_out_ff;

    always @ (*) begin
        clk_out_nxt = clk_out_ff;
        counter_nxt = counter_ff;
        
        if (enable) begin
            counter_nxt = counter_ff + 1'b1;
            
            if ( counter_ff == (MAX_VALUE/2-1) ) begin
                clk_out_nxt = !clk_out_ff;
            end
            if ( counter_ff == (MAX_VALUE-1) ) begin
                clk_out_nxt = !clk_out_ff;
                counter_nxt = 'h0;
            end
        end
    end

    always @ (posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_out_ff <= 1'b0;
            counter_ff <= 'h0;
        end
        else begin
            clk_out_ff <= clk_out_nxt;
            counter_ff <= counter_nxt;
        end
    end
endmodule