`timescale 1 ns / 1 ns 

module anim_gen (
   clk,
   reset,
   x_control,
   stop_ball,
   bottom_button_l,
   bottom_button_r,
   top_button_l,
   top_button_r,
   y_control,
   video_on,
   rgb,
   score1,
   score2,
   player1_score_digit1, player1_score_digit2,player2_score_digit1,player2_score_digit2
   );
 

input clk; 
input reset; 
input[9:0] x_control; 
input stop_ball; 
input bottom_button_l; 
input bottom_button_r; 
input top_button_l; 
input top_button_r; 
input[9:0] y_control; 
input video_on; 
output[2:0] rgb; 
output score1; 
output score2; 
input player1_score_digit1;
input player1_score_digit2;
input player2_score_digit1;
input player2_score_digit2;
wire [3:0] player1_score_digit1;
wire [3:0] player1_score_digit2;
wire [3:0] player2_score_digit1;
wire [3:0] player2_score_digit2;
reg[2:0] rgb; 
reg score1; 
reg score2; 
reg scoreChecker1; 
reg scoreChecker2; 
reg scorer; 
reg scorerNext; 

// topbar
integer topbar_l; // the distance between bar and left side of screen 
integer topbar_l_next; // the distance between bar and left side of screen
parameter topbar_t = 20; // the distance between bar and top side of screen
parameter topbar_thickness = 10; // thickness of the bar
parameter topbar_w = 120; // width of the top bar
parameter topbar_v = 10; //velocity of the bar.
wire display_topbar; //to send top bar to vga
wire[2:0] rgb_topbar; //color 

// bottombar
integer bottombar_l;  // the distance between bar and left side of screen
integer bottombar_l_next; // the distance between bar and left side of screen
parameter bottombar_t = 460; // the distance between bar and top side of screen
parameter bottombar_thickness = 10; //thickness of the bar
parameter bottombar_w = 120; // width of the bottom bar
parameter bottombar_v = 10; //velocity of the bar
wire display_bottombar; //to send bottom bar to vga
wire[2:0] rgb_bottombar; //color

// ball
integer ball_c_l; // the distance between the ball and left side of the screen
integer ball_c_l_next; // the distance between the ball and left side of the screen 
integer ball_c_t; // the distance between the ball and top side of the screen
integer ball_c_t_next; // the distance between the ball and top side of the screen
parameter ball_default_c_t = 300; // default value of the distance between the ball and left side of the screen
parameter ball_default_c_l = 300; // default value of the distance between the ball and left side of the screen
parameter ball_r = 8; //radius of the ball.
parameter horizontal_velocity = 3; // Horizontal velocity of the ball  
parameter vertical_velocity = 3; //Vertical velocity of the ball
wire display_ball; //to send ball to vga 
wire[2:0] rgb_ball;//color 

wire displayUpperText1;
wire displayUpperText2;
wire displayUpperText3;
wire displayUpperText4;
wire displayUpperText5;
wire displayUpperText6;
wire displayUpperText7;
wire displayUpperText8;
wire displayUpperText9;
wire displayUpperText10;
wire displayUpperText11;

wire[7:0] upperText1Ascii;
wire[7:0] upperText2Ascii;
wire[7:0] upperText3Ascii;
wire[7:0] upperText4Ascii;
wire[7:0] upperText5Ascii;
wire[7:0] upperText6Ascii;
wire[7:0] upperText7Ascii;
wire[7:0] upperText8Ascii;
wire[7:0] upperText9Ascii;
wire[7:0] upperText10Ascii;
wire[7:0] upperText11Ascii;

wire displayLowerText1;
wire displayLowerText2;
wire displayLowerText3;
wire displayLowerText4;
wire displayLowerText5;
wire displayLowerText6;
wire displayLowerText7;
wire displayLowerText8;
wire displayLowerText9;
wire displayLowerText10;
wire displayLowerText11;

wire[7:0] lowerText1Ascii;
wire[7:0] lowerText2Ascii;
wire[7:0] lowerText3Ascii;
wire[7:0] lowerText4Ascii;
wire[7:0] lowerText5Ascii;
wire[7:0] lowerText6Ascii;
wire[7:0] lowerText7Ascii;
wire[7:0] lowerText8Ascii;
wire[7:0] lowerText9Ascii;
wire[7:0] lowerText10Ascii;
wire[7:0] lowerText11Ascii;


// refresh
integer refresh_reg; 
integer refresh_next; 
parameter refresh_constant = 830000;  
wire refresh_rate; 

// ball animation
integer horizontal_velocity_reg; 
integer horizontal_velocity_next; 
integer vertical_velocity_reg; 

// x,y pixel cursor
integer vertical_velocity_next; 
wire[9:0] x; 
wire[8:0] y; 


// buffer
reg[2:0] rgb_reg; 

// x,y pixel cursor
wire[2:0] rgb_next; 

initial
    begin
    vertical_velocity_next = 0;
    vertical_velocity_reg = 0;
    horizontal_velocity_reg = 0;
    ball_c_t_next = 300;
    ball_c_t = 300;
    ball_c_l_next = 300;  
    ball_c_l = 300; 
    bottombar_l_next = 260;
    bottombar_l = 260;
    topbar_l_next = 260;
    topbar_l = 260;
   end
assign x = x_control; 
assign y = y_control; 

// refreshing

always @(posedge clk)
   begin //: process_1
   refresh_reg <= refresh_next;   
   end

//assigning refresh logics.
assign refresh_next = refresh_reg === refresh_constant ? 0 : 
	refresh_reg + 1; 
assign refresh_rate = refresh_reg === 0 ? 1'b 1 : 
	1'b 0; 

// register part
always @(posedge clk or posedge reset)
   begin 
   if (reset === 1'b 1) // to reset the game.
      begin
      ball_c_l <= ball_default_c_l;   
      ball_c_t <= ball_default_c_t;   
      bottombar_l <= 260;   
      topbar_l <= 260;   
      horizontal_velocity_reg <= 0;   
      vertical_velocity_reg <= 0;   
      end
   else 
      begin
      horizontal_velocity_reg <= horizontal_velocity_next; //assigns horizontal velocity
      vertical_velocity_reg <= vertical_velocity_next; // assigns vertical velocity
      if (stop_ball === 1'b 1) // throw the ball
         begin
         if (scorer === 1'b 0) // if scorer is not the 1st player throw the ball to 1st player (2nd player scored) .
            begin
            horizontal_velocity_reg <= 3;   
            vertical_velocity_reg <= 3;   
            end
         else // first player scored. Throw the ball to the 2nd player.
            begin
            horizontal_velocity_reg <= -3;   
            vertical_velocity_reg <= -3;   
            end
         end
      ball_c_l <= ball_c_l_next; //assigns the next value of the ball's location from the left side of the screen to it's location.
      ball_c_t <= ball_c_t_next; //assigns the next value of the ball's location from the top side of the screen to it's location.  
      bottombar_l <= bottombar_l_next;   //assigns the next value of the bottom bars's location from the left side of the screen to it's location.
      topbar_l <= topbar_l_next;   //assigns the next value of the top bars's location from the left side of the screen to it's location.
      scorer <= scorerNext;
      end
   end

// bottombar animation
always @(bottombar_l or refresh_rate or bottom_button_r or bottom_button_l)
   begin 
   bottombar_l_next <= bottombar_l;//assign bottombar_l to it's next value   
   if (refresh_rate === 1'b 1) //refresh_rate's posedge 
      begin
      if (bottom_button_l === 1'b 1 & bottombar_l > bottombar_v) //left button is pressed and bottom bar can move to the left.
         begin                                                   // in other words, bar is not on the left edge of the screen.
         bottombar_l_next <= bottombar_l - bottombar_v; // move bottombar to the left   
         end
      else if (bottom_button_r === 1'b 1 & bottombar_l < 639 - bottombar_v - bottombar_w ) //right button is pressed and bottom bar can move to the right 
         begin                                                                             //in other words, bar is not on the right edge of the screen
         bottombar_l_next <= bottombar_l + bottombar_v;   //move bottombar to the right.
         end
      else
         begin
         bottombar_l_next <= bottombar_l;   
         end
      end
   end

// topbar animation
always @(topbar_l or refresh_rate or top_button_r or top_button_l)
   begin 
   topbar_l_next <= topbar_l;   //assign topbar_l to it's next value
   if (refresh_rate === 1'b 1)  //refresh_rate's posedge
      begin
      if (top_button_l === 1'b 1 & topbar_l > topbar_v)//left button is pressed and top bar can move to the left.
          begin                                        // in other words, bar is not on the left edge of the screen.
         topbar_l_next <= topbar_l - topbar_v;   //move top bar to the left
         end
      else if (top_button_r === 1'b 1 & topbar_l < 639 - topbar_v - topbar_w ) //right button is pressed and bottom bar can move to the right 
        begin                                                                  //in other words, bar is not on the right edge of the screen
         topbar_l_next <= topbar_l + topbar_v;   // move top bar to the right
         end
      else
         begin
         topbar_l_next <= topbar_l;   
         end
      end
   end

// ball animation
always @(refresh_rate or ball_c_l or ball_c_t or horizontal_velocity_reg or vertical_velocity_reg)
   begin 
   ball_c_l_next <= ball_c_l;   
   ball_c_t_next <= ball_c_t;   
   scorerNext <= scorer;   
   horizontal_velocity_next <= horizontal_velocity_reg;   
   vertical_velocity_next <= vertical_velocity_reg;   
   scoreChecker1 <= 1'b 0; //1st player did not scored, default value
   scoreChecker2 <= 1'b 0; //2st player did not scored, default value  
   if (refresh_rate === 1'b 1) // posedge of refresh_rate
      begin
      if (ball_c_l >= bottombar_l & ball_c_l <= bottombar_l +120 & ball_c_t >= bottombar_t - 3 & ball_c_t <= bottombar_t + 5) // if ball hits the bottom bar
         begin
         vertical_velocity_next <= -vertical_velocity; // set the direction of vertical velocity positive
         end
      else if (ball_c_l >= topbar_l & ball_c_l <= topbar_l + 120 & ball_c_t >= topbar_t + 2 & ball_c_t <= topbar_t + 12 ) // if ball hits the top bar 
         begin
         vertical_velocity_next <= vertical_velocity; //set the direction of vertical velocity positive  
         end
      if (ball_c_l < 0) // if the ball hits the left side of the screen
         begin
         horizontal_velocity_next <= horizontal_velocity; //set the direction of horizontal velocity positive
         end
      else if (ball_c_l > 620 ) // if the ball hits the right side of the screen
         begin
         horizontal_velocity_next <= -horizontal_velocity; //set the direction of horizontal velocity negative.
         end
      ball_c_l_next <= ball_c_l + horizontal_velocity_reg; //move the ball's horizontal location   
      ball_c_t_next <= ball_c_t + vertical_velocity_reg; // move the ball's vertical location.
      if (ball_c_t === 477) // if player 1 scores, in other words, ball passes through the vertical location of bottom bar.
         begin
         ball_c_l_next <= ball_default_c_l;  //reset the ball's location to its default.  
         ball_c_t_next <= ball_default_c_t;  //reset the ball's location to its default.
         horizontal_velocity_next <= 0; //stop the ball.  
         vertical_velocity_next <= 0; //stop the ball
         scorerNext <= 1'b 0;   
         scoreChecker1 <= 1'b 1; //1st player scored.  
         end
      else
         begin
         scoreChecker1 <= 1'b 0;   
         end
      if (ball_c_t === 3)// if player 2 scores, in other words, ball passes through the vertical location of top bar.
         begin
         ball_c_l_next <= ball_default_c_l; //reset the ball's location to its default.   
         ball_c_t_next <= ball_default_c_t; //reset the ball's location to its default.  
         horizontal_velocity_next <= 0; //stop the ball  
         vertical_velocity_next <= 0; //stop the ball  
         scorerNext <= 1'b 1;   
         scoreChecker2 <= 1'b 1;  // player 2 scored  
         end
      else
         begin
         scoreChecker2 <= 1'b 0;   
         end
      end
   end

// display bottombar object on the screen
assign display_bottombar = x > bottombar_l & x < bottombar_l + bottombar_w & y > bottombar_t & 
    y < bottombar_t + bottombar_thickness ? 1'b 1 : 
	1'b 0; 
assign rgb_bottombar = 3'b 100; //color of bottom bar: blue

// display topbar object on the screen
assign display_topbar = x > topbar_l & x < topbar_l + topbar_w & y > topbar_t &
    y < topbar_t + topbar_thickness ? 1'b 1 : 
	1'b 0; 
assign rgb_topbar = 3'b 001; // color of top bar: red

// display ball object on the screen
assign display_ball = (x - ball_c_l) * (x - ball_c_l) + (y - ball_c_t) * (y - ball_c_t) <= ball_r * ball_r ? 
    1'b 1 : 
	1'b 0; 
assign rgb_ball = 3'b 111; //color of ball: white

// assign displayText1 = x > 100 & x < 120 & y > 100 & y < 120 ? 1'b 1 : 1'b 0;
// assign displayText2 = x > 125 & x < 145 & y > 100 & y < 120 ? 1'b 1 : 1'b 0;
// assign displayText3 = x > 150 & x < 170 & y > 100 & y < 120 ? 1'b 1 : 1'b 0;
// assign displayText4 = x > 175 & x < 195 & y > 100 & y < 120 ? 1'b 1 : 1'b 0;
// assign displayText5 = x > 200 & x < 220 & y > 100 & y < 120 ? 1'b 1 : 1'b 0;
// assign displayText6 = x > 225 & x < 245 & y > 100 & y < 120 ? 1'b 1 : 1'b 0;
// assign displayText7 = x > 250 & x < 270 & y > 100 & y < 120 ? 1'b 1 : 1'b 0;
// assign displayText8 = x > 275 & x < 295 & y > 100 & y < 120 ? 1'b 1 : 1'b 0;
// assign displayText9 = x > 300 & x < 320 & y > 100 & y < 120 ? 1'b 1 : 1'b 0;
// assign displayText10 = x > 325 & x < 345 & y > 100 & y < 120 ? 1'b 1 : 1'b 0;
assign displayUpperText1 = x > 100 & x < 140 & y > 100 & y < 140 ? 1'b 1 : 1'b 0;
assign displayUpperText2 = x > 140 & x < 180 & y > 100 & y < 140 ? 1'b 1 : 1'b 0;
assign displayUpperText3 = x > 180 & x < 220 & y > 100 & y < 140 ? 1'b 1 : 1'b 0;
assign displayUpperText4 = x > 220 & x < 260 & y > 100 & y < 140 ? 1'b 1 : 1'b 0;
assign displayUpperText5 = x > 260 & x < 300 & y > 100 & y < 140 ? 1'b 1 : 1'b 0;
assign displayUpperText6 = x > 300 & x < 340 & y > 100 & y < 140 ? 1'b 1 : 1'b 0;
assign displayUpperText7 = x > 340 & x < 380 & y > 100 & y < 140 ? 1'b 1 : 1'b 0;
assign displayUpperText8 = x > 380 & x < 420 & y > 100 & y < 140 ? 1'b 1 : 1'b 0;
assign displayUpperText9 = x > 420 & x < 460 & y > 100 & y < 140 ? 1'b 1 : 1'b 0;
assign displayUpperText10 = x > 460 & x < 500 & y > 100 & y < 140 ? 1'b 1 : 1'b 0;
assign displayUpperText11 = x > 500 & x < 540 & y > 100 & y < 140 ? 1'b 1 : 1'b 0;

assign displayLowerText1 = x > 100 & x < 140 & y > 340 & y < 380 ? 1'b 1 : 1'b 0;
assign displayLowerText2 = x > 140 & x < 180 & y > 340 & y < 380 ? 1'b 1 : 1'b 0;
assign displayLowerText3 = x > 180 & x < 220 & y > 340 & y < 380 ? 1'b 1 : 1'b 0;
assign displayLowerText4 = x > 220 & x < 260 & y > 340 & y < 380 ? 1'b 1 : 1'b 0;
assign displayLowerText5 = x > 260 & x < 300 & y > 340 & y < 380 ? 1'b 1 : 1'b 0;
assign displayLowerText6 = x > 300 & x < 340 & y > 340 & y < 380 ? 1'b 1 : 1'b 0;
assign displayLowerText7 = x > 340 & x < 380 & y > 340 & y < 380 ? 1'b 1 : 1'b 0;
assign displayLowerText8 = x > 380 & x < 420 & y > 340 & y < 380 ? 1'b 1 : 1'b 0;
assign displayLowerText9 = x > 420 & x < 460 & y > 340 & y < 380 ? 1'b 1 : 1'b 0;
assign displayLowerText10 = x > 460 & x < 500 & y > 340 & y < 380 ? 1'b 1 : 1'b 0;
assign displayLowerText11 = x > 500 & x < 540 & y > 340 & y < 380 ? 1'b 1 : 1'b 0;

wire player1_score;
wire player2_score;
assign player1_score = (player1_score_digit2 * 10) + player1_score_digit1;
assign player2_score = (player2_score_digit2 * 10) + player2_score_digit1;

wire lowerWinning = player1_score < player2_score;
wire upperWinning = player1_score > player2_score;
wire tie = player1_score === player2_score;
wire gameEnd = player1_score > 99 || player2_score > 99;

wire [11:0] player1_score_ascii1;
wire [11:0] player1_score_ascii2;
wire [11:0] player2_score_ascii1;
wire [11:0] player2_score_ascii2;

assign player1_score_ascii1 = player1_score_digit1 + 8'h30;
assign player1_score_ascii2 = player1_score_digit2 + 8'h30;
assign player2_score_ascii1 = player2_score_digit1 + 8'h30;
assign player2_score_ascii2 = player2_score_digit2 + 8'h30;
// assign lowerText1Ascii = lowerWinning ? 8'h4C : tie ? 8'h41 : 8'h4C; 
assign upperText1Ascii  = gameEnd ? (upperWinning  ? 8'h45 : 8'h54) : upperWinning ? 8'h4C : tie ? 8'h41 : 8'h4C; //E or T or L or A or L
assign upperText2Ascii  = gameEnd ? (upperWinning  ? 8'h5A : 8'h72) : upperWinning ? 8'h65 : tie ? 8'h6C : 8'h6F; //Z or r or e or l or o
assign upperText3Ascii  = gameEnd ? (upperWinning  ? 8'h20 : 8'h79) : upperWinning ? 8'h61 : tie ? 8'h6C : 8'h73; //  or y or a or l or s
assign upperText4Ascii  = gameEnd ? (upperWinning  ? 8'h57 : 8'h20) : upperWinning ? 8'h64 : tie ? 8'h55 : 8'h69; //W or   or d or U or i
assign upperText5Ascii  = gameEnd ? (upperWinning  ? 8'h69 : 8'h48) : upperWinning ? 8'h69 : tie ? 8'h68 : 8'h6E; //i or H or i or h or n
assign upperText6Ascii  = gameEnd ? (upperWinning  ? 8'h6E : 8'h61) : upperWinning ? 8'h6E : tie ? 8'h61 : 8'h67; //n or a or n or a or g
assign upperText7Ascii  = gameEnd ? (upperWinning  ? 8'h20 : 8'h72) : upperWinning ? 8'h67 : tie ? 8'h76 : 8'h20; //  or r or g or v or  
assign upperText8Ascii  = gameEnd ? (upperWinning  ? 8'h20 : 8'h64) : upperWinning ? 8'h20 : tie ? 8'h65 : 8'h20; //  or d or   or e or  
assign upperText9Ascii  = gameEnd ? (upperWinning  ? 8'h20 : 8'h65) : upperWinning ? 8'h20 : tie ? 8'h3F : 8'h20; //  or e or   or ? or  
assign upperText10Ascii = gameEnd ? (upperWinning  ? 8'h20 : 8'h72) : player1_score_ascii2       ; //  or r or 0 or 0 or 0
assign upperText11Ascii = gameEnd ? (upperWinning  ? 8'h20 : 8'h20) : player1_score_ascii1       ; //  or   or 0 or 0 or 0

assign lowerText1Ascii  = gameEnd ? (lowerWinning  ? 8'h45 : 8'h54) : lowerWinning ? 8'h4C : tie ? 8'h41 : 8'h4C; //E or T or L or A or L
assign lowerText2Ascii  = gameEnd ? (lowerWinning  ? 8'h5A : 8'h72) : lowerWinning ? 8'h65 : tie ? 8'h6C : 8'h6F; //Z or r or e or l or o
assign lowerText3Ascii  = gameEnd ? (lowerWinning  ? 8'h20 : 8'h79) : lowerWinning ? 8'h61 : tie ? 8'h6C : 8'h73; //  or y or a or l or s
assign lowerText4Ascii  = gameEnd ? (lowerWinning  ? 8'h57 : 8'h20) : lowerWinning ? 8'h64 : tie ? 8'h55 : 8'h69; //W or   or d or U or i
assign lowerText5Ascii  = gameEnd ? (lowerWinning  ? 8'h69 : 8'h48) : lowerWinning ? 8'h69 : tie ? 8'h68 : 8'h6E; //i or H or i or h or n
assign lowerText6Ascii  = gameEnd ? (lowerWinning  ? 8'h6E : 8'h61) : lowerWinning ? 8'h6E : tie ? 8'h61 : 8'h67; //n or a or n or a or g
assign lowerText7Ascii  = gameEnd ? (lowerWinning  ? 8'h20 : 8'h72) : lowerWinning ? 8'h67 : tie ? 8'h76 : 8'h20; //  or r or g or v or  
assign lowerText8Ascii  = gameEnd ? (lowerWinning  ? 8'h20 : 8'h64) : lowerWinning ? 8'h20 : tie ? 8'h65 : 8'h20; //  or d or   or e or
assign lowerText9Ascii  = gameEnd ? (lowerWinning  ? 8'h20 : 8'h65) : lowerWinning ? 8'h20 : tie ? 8'h3F : 8'h20; //  or e or   or ? or
assign lowerText10Ascii = gameEnd ? (lowerWinning  ? 8'h20 : 8'h72) : player2_score_ascii1       ; //  or r or 0 or 0 or 0
assign lowerText11Ascii = gameEnd ? (lowerWinning  ? 8'h20 : 8'h20) : player2_score_ascii2       ; //  or   or 0 or 0 or 0

wire [2:0] upperText1;
wire [2:0] upperText2;
wire [2:0] upperText3;
wire [2:0] upperText4;
wire [2:0] upperText5;
wire [2:0] upperText6;
wire [2:0] upperText7;
wire [2:0] upperText8;
wire [2:0] upperText9;
wire [2:0] upperText10;
wire [2:0] upperText11;

wire [2:0] lowerText1;
wire [2:0] lowerText2;
wire [2:0] lowerText3;
wire [2:0] lowerText4;
wire [2:0] lowerText5;
wire [2:0] lowerText6;
wire [2:0] lowerText7;
wire [2:0] lowerText8;
wire [2:0] lowerText9;
wire [2:0] lowerText10;
wire [2:0] lowerText11;

char_rom char_rom1(upperText1Ascii, ((x - 100) % 40)/5, ((y - 100) % 40)/5, upperText1);
char_rom char_rom2(upperText2Ascii, ((x - 140) % 40)/5, ((y - 100) % 40)/5, upperText2);
char_rom char_rom3(upperText3Ascii, ((x - 180) % 40)/5, ((y - 100) % 40)/5, upperText3);
char_rom char_rom4(upperText4Ascii, ((x - 220) % 40)/5, ((y - 100) % 40)/5, upperText4);
char_rom char_rom5(upperText5Ascii, ((x - 260) % 40)/5, ((y - 100) % 40)/5, upperText5);
char_rom char_rom6(upperText6Ascii, ((x - 300) % 40)/5, ((y - 100) % 40)/5, upperText6);
char_rom char_rom7(upperText7Ascii, ((x - 340) % 40)/5, ((y - 100) % 40)/5, upperText7);
char_rom char_rom8(upperText8Ascii, ((x - 380) % 40)/5, ((y - 100) % 40)/5, upperText8);
char_rom char_rom9(upperText9Ascii, ((x - 420) % 40)/5, ((y - 100) % 40)/5, upperText9);
char_rom char_rom10(upperText10Ascii, ((x - 460) % 40)/5, ((y - 100) % 40)/5, upperText10);
char_rom char_rom11(upperText11Ascii, ((x - 500) % 40)/5, ((y - 100) % 40)/5, upperText11);

char_rom char_rom12(lowerText1Ascii, ((x - 100) % 40)/5, ((y - 340) % 40)/5, lowerText1);
char_rom char_rom13(lowerText2Ascii, ((x - 140) % 40)/5, ((y - 340) % 40)/5, lowerText2);
char_rom char_rom14(lowerText3Ascii, ((x - 180) % 40)/5, ((y - 340) % 40)/5, lowerText3);
char_rom char_rom15(lowerText4Ascii, ((x - 220) % 40)/5, ((y - 340) % 40)/5, lowerText4);
char_rom char_rom16(lowerText5Ascii, ((x - 260) % 40)/5, ((y - 340) % 40)/5, lowerText5);
char_rom char_rom17(lowerText6Ascii, ((x - 300) % 40)/5, ((y - 340) % 40)/5, lowerText6);
char_rom char_rom18(lowerText7Ascii, ((x - 340) % 40)/5, ((y - 340) % 40)/5, lowerText7);
char_rom char_rom19(lowerText8Ascii, ((x - 380) % 40)/5, ((y - 340) % 40)/5, lowerText8);
char_rom char_rom20(lowerText9Ascii, ((x - 420) % 40)/5, ((y - 340) % 40)/5, lowerText9);
char_rom char_rom21(lowerText10Ascii, ((x - 460) % 40)/5, ((y - 340) % 40)/5, lowerText10);
char_rom char_rom22(lowerText11Ascii, ((x - 500) % 40)/5, ((y - 340) % 40)/5, lowerText11);



always @(posedge clk)
   begin 
   rgb_reg <= rgb_next;   
   end

// mux to display
wire[3:0] output_mux; 
wire showText = displayUpperText1 | displayUpperText2 | displayUpperText3 | displayUpperText4 | displayUpperText5 | displayUpperText6 | displayUpperText7 | displayUpperText8 | displayUpperText9 | displayUpperText10 | displayUpperText11 | displayLowerText1 | displayLowerText2 | displayLowerText3 | displayLowerText4 | displayLowerText5 | displayLowerText6 | displayLowerText7 | displayLowerText8 | displayLowerText9 | displayLowerText10 | displayLowerText11;

// mux
assign output_mux = {video_on, display_topbar, display_bottombar, display_ball}; 

//assign rgb_next wrt output_mux.
assign rgb_next =
   (video_on && showText) ? 
   (displayUpperText1 ? upperText1 :
   displayUpperText2 ? upperText2 :
   displayUpperText3 ? upperText3 :
   displayUpperText4 ? upperText4 :
   displayUpperText5 ? upperText5 :
   displayUpperText6 ? upperText6 :
   displayUpperText7 ? upperText7 :
   displayUpperText8 ? upperText8 :
   displayUpperText9 ? upperText9 :
   displayUpperText10 ? upperText10 :
   displayUpperText11 ? upperText11 :
   displayLowerText1 ? lowerText1 :
   displayLowerText2 ? lowerText2 :
   displayLowerText3 ? lowerText3 :
   displayLowerText4 ? lowerText4 :
   displayLowerText5 ? lowerText5 :
   displayLowerText6 ? lowerText6 :
   displayLowerText7 ? lowerText7 :
   displayLowerText8 ? lowerText8 :
   displayLowerText9 ? lowerText9 :
   displayLowerText10 ? lowerText10 :
   lowerText11) :
   output_mux === 4'b 1000 ? 3'b 000 : 
	output_mux === 4'b 1100 ? rgb_bottombar : 
	output_mux === 4'b 1101 ? rgb_bottombar : 
	output_mux === 4'b 1010 ? rgb_topbar : 
	output_mux === 4'b 1011 ? rgb_topbar : 
	output_mux === 4'b 1001 ? rgb_ball : 
   output_mux === 4'b 1111 ? rgb_ball :
	3'b 000; 
	

// output part
assign rgb = rgb_reg; 
assign score1 = scoreChecker1; 
assign score2 = scoreChecker2; 

endmodule // end of module anim_gen
