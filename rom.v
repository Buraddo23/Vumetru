`timescale 1ns/1ns

module rom (clk, address, data);
    parameter SIZE = 8,
              FILE = "";
    
    input [15:0] address;
    output reg [SIZE:0] data;
    input clk;
    
    reg [SIZE:0] mem [0:65535];
    
    initial begin
        $readmemh(FILE, mem);
    end
    
    always @ (posedge clk)
    begin
        data <= mem[address];
    end
endmodule