`timescale 1ns / 1ps

module main_control(
    input logic clk,
    input logic start,   
    // input logic reset,
//    input logic bottom_button_l,
//    input logic bottom_button_r,
//    input logic top_button_l,
//    input logic top_button_r,
    // input logic start_ball,
    output logic[2:0] rgb, 
    output logic horizontal_sync,
    output logic vertical_sync,
    output a, b, c, d, e, f, g, dp,
        output wire RsTx, //uart
    input wire RsRx, //uart
                     output [3:0] an  ); 

reg score_checker1;
reg score_checker2;
reg [3:0] player1_score_digit1;
reg [3:0] player1_score_digit2;
reg [3:0] player2_score_digit1;
reg [3:0] player2_score_digit2;

initial 
                        begin : process_0
                        player1_score_digit1 = 'b0000;   
                        player1_score_digit2 = 'b0000;
                        player2_score_digit1 = 'b0000;   
                        player2_score_digit2 = 'b0000;
                        score_checker1 = 0;
                        score_checker2 = 0;
                        end

//signal x,y:std_logic_vector(9 downto 0);
reg[9:0] x_control;
reg[9:0] y_control;

//signal video:std_logic;
reg video_on;

wire top_button_l;
wire top_button_r;
wire bottom_button_l;
wire bottom_button_r;
wire start_ball;
wire reset;

//signal clk_50 :std_logic;
reg clk_50;


//Vivado CLK wizzard to create 50MHz clock 
clk_wiz_0(clk_50, reset, clk);

//Module to create animations
anim_gen(clk_50, reset, x_control,start_ball, bottom_button_l, bottom_button_r,top_button_l,top_button_r, y_control, video_on, rgb, score_checker1, score_checker2, player1_score_digit1, player1_score_digit2,player2_score_digit1,player2_score_digit2);

//vga synchronization module to update changing pixels and refresh the display
sync_mod(clk_50, reset, start, y_control, x_control, horizontal_sync, vertical_sync, video_on);

controller(clk,RsRx,RsTx, bottom_button_l, bottom_button_r,top_button_l,top_button_r, start_ball, reset);
//if score checker1 is enabled that means player 1(topbar) scored, so update  his score
always_ff @(posedge clk_50, posedge reset)
begin
    if ((player1_score_digit1 == 9 && player1_score_digit2 == 9) || ( player2_score_digit1 == 9 && 9 == player2_score_digit2))
    begin
    end
    else if ( reset == 1)
    begin
        player1_score_digit2 <= 0;
        player1_score_digit1 <= 0;
    end
    else if (player1_score_digit1 == 9 && score_checker1 == 1)
    begin
        player1_score_digit1 <= 0;
        player1_score_digit2++;
    end
    else if (score_checker1 == 1)
    begin
        player1_score_digit1++;
    end
end

//if score checker2 is enabled that means player2 (bottom bar) scored, so update his score
always_ff @(posedge clk_50, posedge reset)
begin
    //  (player2_score_digit2 == 9 && player2_score_digit1 == 9 && score_checker2 == 1)||
    if ((player1_score_digit1 == 9 && player1_score_digit2 == 9) || (player2_score_digit1 == 9 && 9 == player2_score_digit2))
    begin
    end
    else if ( reset == 1)
    begin
        player2_score_digit2 <= 0;
        player2_score_digit1 <= 0;
    end
    else if (player2_score_digit1 == 9 && score_checker2 == 1)
    begin
        player2_score_digit1 <= 0;
        player2_score_digit2++;
    end
    else if (score_checker2 == 1)
    begin
        player2_score_digit1++;
    end
end


//Module to display the scores on the 7seg display of basys3
SevenSegment(clk_50,player1_score_digit1,player1_score_digit2,player2_score_digit1,player2_score_digit2,a, b, c, d, e, f, g, dp,an);
wire noobvivado3;            
endmodule
