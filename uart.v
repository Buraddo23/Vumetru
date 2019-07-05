`timescale 1ns/1ns

module uart(rx, clkx16, reset, data, load, error);
    parameter IDLE      = 3'b000,
              DET_START = 3'b001,
              READ      = 3'b010,
              DET_STOP  = 3'b011,
              ERR       = 3'b100;
    
    input rx, reset, clkx16;
    output [7:0] data;
    output load;
    output error;

    reg [7:0] data_ff, data_nxt;
    reg load_ff, load_nxt;
    reg [2:0] state_ff, state_nxt;
    reg [2:0] count_ff, count_nxt;
    reg error_ff, error_nxt;
    reg [3:0] count_zero_ff, count_zero_nxt, count_one_ff, count_one_nxt, count_sample_ff, count_sample_nxt;

    assign data = data_ff;
    assign load = load_ff;
    assign error = error_ff;

    always @ (*) begin
        data_nxt  = data_ff;
        load_nxt  = load_ff;
        state_nxt = state_ff;
        count_nxt = count_ff;
        error_nxt = error_ff;
        count_zero_nxt = count_zero_ff;
        count_one_nxt = count_one_ff;
        count_sample_nxt = count_sample_ff;
        
        case (state_ff)
            IDLE: begin
                data_nxt = 8'b0;
                load_nxt = 1'b0;
                
                if (rx === 1'b0) begin
                    state_nxt = DET_START;
                end
            end
            DET_START: begin             
                count_sample_nxt = count_sample_ff + 1'b1;
                if ( rx === 1'b0 ) begin
                    count_zero_nxt = count_zero_ff + 1'b1;
                end
                else if ( rx === 1'b1 )  begin
                    count_one_nxt = count_one_ff + 1'b1;
                end
                
                if(count_sample_ff >= 4'hE) begin
                    if (count_zero_ff > count_one_ff) begin
                        state_nxt = READ;
                        count_nxt = 3'b111;
                        count_sample_nxt = 4'b0;
                    end
                    else begin
                        state_nxt = IDLE;
                    end
                    
                    count_zero_nxt = 4'b0;
                    count_one_nxt = 4'b0;
                    count_sample_nxt = 4'b0;
                end                
            end
            READ: begin
                count_sample_nxt = count_sample_ff + 4'h1;
                if ( rx === 1'b0 ) begin
                    count_zero_nxt = count_zero_ff + 1'b1;
                end
                else if ( rx === 1'b1 )  begin
                    count_one_nxt = count_one_ff + 1'b1;
                end
                
                if(count_sample_ff >= 4'hF) begin
                    if (count_zero_ff > count_one_ff) begin
                        data_nxt = data_ff | (1'b0 << count_ff);
                    end
                    else begin
                        data_nxt = data_ff | (1'b1 << count_ff);
                    end
                    
                    count_zero_nxt = 4'b0;
                    count_one_nxt = 4'b0;
                    count_sample_nxt = 4'b0;
                    
                    if (count_ff === 1'b0) begin
                        state_nxt = DET_STOP;
                    end
                    else begin
                        count_nxt = count_ff - 1'b1;
                    end
                end
            end
            DET_STOP: begin
                count_sample_nxt = count_sample_ff + 1'b1;
                if ( rx === 1'b0 ) begin
                    count_zero_nxt = count_zero_ff + 1'b1;
                end
                else if ( rx === 1'b1 )  begin
                    count_one_nxt = count_one_ff + 1'b1;
                end
                
                if(count_sample_ff >= 4'hF) begin
                    if (count_zero_ff > count_one_ff) begin
                        state_nxt = ERR;
                        error_nxt = 1'b1;
                    end
                    else begin
                        load_nxt = 1'b1;
                        state_nxt = IDLE;
                    end
                    
                    count_zero_nxt = 4'b0;
                    count_one_nxt = 4'b0;
                    count_sample_nxt = 4'b0;
                end
            end
            ERR: begin
                if (rx === 1'b1) begin
                    state_nxt = IDLE;
                end
            end
        endcase
    end

    always @ (posedge clkx16 or posedge reset) begin
        if (reset) begin
            data_ff  <= 8'b0;
            load_ff  <= 1'b0;
            state_ff <= IDLE;
            count_ff <= 3'b0;
            error_ff <= 1'b0;
            count_zero_ff <= 4'b0;
            count_one_ff <= 4'b0;
            count_sample_ff <= 4'b0;
        end
        else begin
            data_ff <= data_nxt;
            load_ff <= load_nxt;
            state_ff <= state_nxt;
            count_ff <= count_nxt;
            error_ff <= error_nxt;
            count_zero_ff <= count_zero_nxt;
            count_one_ff <= count_one_nxt;
            count_sample_ff <= count_sample_nxt;
        end
    end
endmodule