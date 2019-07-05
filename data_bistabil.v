`timescale 1ns/1ns

module data_bistabil(clock, enable, reset, data_in, load, error, data_out);

    input clock, enable, reset, load, error;
    input [7:0] data_in;
    output [7:0] data_out;
    
    reg [7:0] data_out_ff, data_out_nxt;
    
    assign data_out = data_out_ff;
    
    always @ (*) begin
        data_out_nxt = data_out_ff;
        
        if (enable) begin
            if (load && !error) begin
                data_out_nxt = data_in;
            end 
            else begin
                data_out_nxt = data_out_ff;
            end
        end
    end
    
    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            data_out_ff <= 8'hff;
        end
        else begin
            data_out_ff <= data_out_nxt;
        end        
    end
    
endmodule