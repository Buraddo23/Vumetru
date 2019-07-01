`timescale 1ns/1ns

module clk_gen(clk_in, clk_out, enable, reset);
    parameter in_freq = 1, 
              out_freq = 1,
              max_value = in_freq / out_freq,
//              bit_size = $clog2(max_value);
              bit_size = 13;

    input clk_in, enable, reset;
    output clk_out;

    reg clk_out_ff, clk_out_nxt;
    reg [bit_size:0] counter_ff, counter_nxt;
    
    assign clk_out = clk_out_ff;

    always @ (*) begin
        clk_out_nxt = clk_out_ff;
        counter_nxt = counter_ff;
        
        if (enable) begin
            counter_nxt = counter_ff + 1'b1;
            
            if ( counter_ff == (max_value/2-1) ) begin
                clk_out_nxt = !clk_out_ff;
            end
            if ( counter_ff == (max_value-1) ) begin
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