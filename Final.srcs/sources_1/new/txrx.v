`timescale 1ns / 1ps

module uart_tx(
    input clk,
    input [7:0] payload,
    input enable,
    output reg sent,
    output reg bit_out
    );
    
    reg last_enable;
    reg sending = 0;
    reg [7:0] count;
    reg [7:0] temp;
    
    always@(posedge clk) begin
        if (~sending & ~last_enable& enable) begin
            temp <= payload;
            sending <= 1;
            sent <= 0;
            count <= 0;
        end
        
        last_enable <= enable;
        
        if (sending)    count <= count + 1;
        else            begin count <= 0; bit_out <= 1; end
        
        // sampling every 16 ticks
        case (count)
            8'd8: bit_out <= 0;
            8'd24: bit_out <= temp[0];  
            8'd40: bit_out <= temp[1];
            8'd56: bit_out <= temp[2];
            8'd72: bit_out <= temp[3];
            8'd88: bit_out <= temp[4];
            8'd104: bit_out <= temp[5];
            8'd120: bit_out <= temp[6];
            8'd136: bit_out <= temp[7];
            8'd152: begin sent <= 1; sending <= 0; end
        endcase
    end
endmodule


module uart_rx(
    input clk,
    input bit_in,
    output reg done,
    output reg [7:0] data
    );
    
    reg last_bit;
    reg receiving = 0;
    reg [7:0] count;
    
    always@(posedge clk) begin
        if (~receiving & last_bit & ~bit_in) begin
            receiving <= 1;
            done <= 0;
            count <= 0;
        end

        last_bit <= bit_in;
        count <= (receiving) ? count+1 : 0;
        
        // sampling every 16 ticks
        case (count)
            8'd24:  data[0] <= bit_in;
            8'd40:  data[1] <= bit_in;
            8'd56:  data[2] <= bit_in;
            8'd72:  data[3] <= bit_in;
            8'd88:  data[4] <= bit_in;
            8'd104: data[5] <= bit_in;
            8'd120: data[6] <= bit_in;
            8'd136: data[7] <= bit_in;
            8'd152: begin done <= 1; receiving <= 0; end
        endcase
    end
endmodule

