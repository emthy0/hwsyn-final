`timescale 1ns / 1ps
module baudrate_gen(
    input clk,
    output reg baud
    );
    
    integer counter;
    always @(posedge clk) begin
        counter = counter + 1;
        if (counter == 325) begin counter = 0; baud = ~baud; end 
        // Clock = 10ns
        // ClockFreq = 1/10ns = 100 MHz
        // Baudrate = 9600
        // counter = ClockFreq/Baudrate/16/2
        // sampling every 16 ticks
    end
    
endmodule

module controller(
    input clk,
    input RsRx,
    output RsTx,
     output reg bottom_button_l, 
    output reg bottom_button_r,
    output reg top_button_l,
    output reg top_button_r
    );
    
    reg enable, last_rec;
    reg [7:0] payload;
    wire [7:0] incoming_data;
    wire sent, received, baud;
    
    baudrate_gen baudrate_gen(clk, baud);
    uart_rx receiver(baud, RsRx, received, incoming_data);
    uart_tx transmitter(baud, payload, enable, sent, RsTx);
    
    always @(posedge baud) begin
        if (enable) begin 
            enable = 0;
//            top_button_l = 1'b 0;
//            top_button_r = 1'b 0;
//            bottom_button_l = 1'b 0;
//            bottom_button_r = 1'b 0;
        end
        if (~last_rec & received) begin
            payload = incoming_data;
            top_button_l = 1'b 0;
            top_button_r = 1'b 0;
            bottom_button_l = 1'b 0;
            bottom_button_r = 1'b 0;
            case(payload)
                8'h61: top_button_l = 1'b 1;
                8'h64: top_button_r = 1'b 1;
                8'h6A: bottom_button_l = 1'b 1;
                8'h6C: bottom_button_r = 1'b 1;
            endcase
            if (payload <= 8'h7A && payload >= 8'h41) enable = 1;
        end
        last_rec = received;
    end
    
endmodule