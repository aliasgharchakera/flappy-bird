module pixel_gen(clk, pixel_x, pixel_y, video_on, bird_x, bird_y, red, green, blue);
  input clk;
  input [9:0] pixel_x;
  input [9:0] pixel_y;
  input video_on;

  input [9:0] bird_x;
  input [9:0] bird_y;
  output reg [3:0]red = 0;
  output reg [3:0]green = 0;
  output reg [3:0]blue = 0;
  
  reg [9:0] display_x = 300;
  reg [9:0] display_y = 460;
  reg [9:0] ball_x = 320;
  reg [9:0] ball_y = 240;
  reg [3:0] collision_state = 0;
  reg ball;
  reg paddle;
  reg [22:0] counter = 0;
  
  reg [9:0] ball_x1;
  reg [9:0] ball_x2;
  reg [9:0] ball_y1;
  reg [9:0] ball_y2;
          
  reg [9:0] paddle_x1; 
  reg [9:0] paddle_x2;
  reg [9:0] paddle_y1;
  reg [9:0] paddle_y2;
  
  always @(posedge clk)
    begin
    counter <= counter + 1;
//       if ((pixel_x == 0) || (pixel_x == 639) || (pixel_y == 0) || (pixel_y == 479))
      if ((pixel_x >= 0 && pixel_x <= 10) || (pixel_x >= 630 && pixel_x <= 640) || (pixel_y >= 0 && pixel_y <= 10) || (pixel_y >= 470 && pixel_y <= 480))
        begin
          red <= 4'h0;
          green <= 4'h0;
          blue <= 4'hF;
        end
      else
        begin
        if (counter >= 4999999)
        begin
        if ( == 108)
        begin
          display_x <= (display_x <= 50) ? display_x : display_x - 50;
        end
      if (rxdata == 114)
        begin
        display_x <= (display_x >= 590) ? display_x : display_x + 50;
        end
      if (rxdata == 100)
        begin
        display_x <= display_x;
        end
          
      case(collision_state)
        0 : begin // initial state, moving down towards the paddle
          ball_x <= ball_x - 20;
          ball_y <= ball_y + 20;
        end
        1 : begin // If collided with paddle (left side => paddle_x -- paddle_x1), enter state 1 and start moving towards left wall
          ball_x <= ball_x - 20;
          ball_y <= ball_y - 20;
        end
        2 : begin /// If collided with the paddle (right side => paddle_x -- paddle_x2), enter state 2 and start moving right towards the top
          ball_x <= ball_x + 20;
          ball_y <= ball_y - 20;
        end
        3 : begin // If collided with left wall from bottom, enter state 3 and start moving right towards the top
          ball_x <= ball_x + 20; 
          ball_y <= ball_y - 20;
        end
        4 : begin // If collided with left wall from top, enter state 4 and start moving down towards right
          ball_x <= ball_x + 20;
          ball_y <= ball_y + 20;
        end
        5 : begin // If collided with top wall from left, enter state 5 and start moving down towards right
          ball_x <= ball_x + 20;
          ball_y <= ball_y + 20;
        end
        6 : begin // If collided with top wall from right, enter state 6 and start moving down towards left
          ball_x <= ball_x - 20;
          ball_y <= ball_y + 20;
        end
        7 : begin // If collided with right wall from top, enter state 7 and start moving down towards left
          ball_x <= ball_x - 20;
          ball_y <= ball_y + 20;
        end
        8 : begin // If collided with right wall from bottom, enter state 8 and start moving up towards left
          ball_x <= ball_x - 20;
          ball_y <= ball_y - 20;
        end
        9 : begin // If missed the paddle and collided with bottom wall from either side, endter state 9
          ball_x <= 320;
          ball_y <= 240;
        end
      endcase
          
      ball_x1 = ball_x - 10;
      ball_x2 = ball_x + 10;
      ball_y1 = ball_y - 10;
      ball_y2 = ball_y + 10;
          
      paddle_x1 = display_x - 50; 
      paddle_x2 = display_x + 50;
      paddle_y1 = display_y - 10;
      paddle_y2 = display_y + 10;
      
      case (collision_state)
        0 : begin
          if (ball_y2 >= paddle_y2) begin
            collision_state <= 9;
          end
          if (ball_y2 >= paddle_y1 && ball_x >= paddle_x1 && ball_x <= paddle_x2) begin
            if (ball_x <= display_x) begin
              collision_state <= 1;
            end
            else begin
              collision_state <= 2;
            end
          end
        end
        1 : begin
          if (ball_x1 <= 10) begin
            collision_state <= 3;
          end
        end
        2 : begin
          if (ball_x2 >= 630) begin
            collision_state <= 8;
          end
        end
        3 : begin
          if (ball_y1 <= 10) begin
            collision_state <= 5;
          end
        end
        4 : begin 
          if (ball_y2 >= paddle_y2) begin
            collision_state <= 9;
          end
          if (ball_y2 >= paddle_y1 && ball_x >= paddle_x1 && ball_x <= paddle_x2) begin
            if (ball_x <= display_x) begin
              collision_state <= 1;
            end
            else begin
              collision_state <= 2;
            end
          end
        end
        5 : begin
          if (ball_x2 >= 630) begin
            collision_state <= 7;
          end
        end
        6 : begin
          if (ball_x1 <= 10) begin
            collision_state <= 4;
          end
        end
        7 : begin
          if (ball_y2 >= paddle_y2) begin
            collision_state <= 9;
          end
          if (ball_y2 >= paddle_y1 && ball_x >= paddle_x1 && ball_x <= paddle_x2) begin
            if (ball_x <= display_x) begin
              collision_state <= 1;
            end
            else begin
              collision_state <= 2;
            end
          end
        end
        8 : begin
          if (ball_y1 <= 10) begin
            collision_state <= 6;
          end
        end
        9 : begin
          collision_state <= 0;
        end
      endcase
      counter <= 0;
      end
          paddle = pixel_y > 450 && pixel_y < 470 && pixel_x > display_x-50 && pixel_x < display_x+50;
          ball = pixel_y > ball_y-10 && pixel_y < ball_y+10 && pixel_x > ball_x-10 && pixel_x < ball_x+10;
          blue <= video_on ? ((ball || paddle) ? 4'hF : 4'h0) : 4'h0;
          red <= 4'h0;
          green <= video_on ? ((ball || paddle) ? 4'hF : 4'h0) : 4'h0;
        end
    end

endmodule