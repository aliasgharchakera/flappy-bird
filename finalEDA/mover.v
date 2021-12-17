module mover(clk, dir, reset2, bird_x, bird_y, pipe1_x, pipe1y_up, pipe2_x, pipe2y_up, pipe3_x, pipe3y_up);
  input clk;
  //reset;
  input [2:0] dir;
  reg [2:0] c_state;
  reg [2:0] state;
  reg [2:0] next;
  parameter UP = 3'b010;
  parameter DOWN = 3'b100;
  parameter START = 3'b000;
  parameter RESET = 3'b111;
  output reg reset2;
  output reg [9:0] bird_x = 30;
  output reg [9:0] bird_y = 230;

  output reg [9:0] pipe1_x = 300;
  output reg [9:0] pipe1y_up = 300;
  // output reg [9:0] pipe1y_down = 380;

  output reg [9:0] pipe2_x = 500;
  output reg [9:0] pipe2y_up = 100;
  // output reg [9:0] pipe2_down = 180;

  output reg [9:0] pipe3_x = 100;
  output reg [9:0] pipe3y_up = 200;
  // output reg [9:0] pipe3y_down = 280;

  reg [22:0] counter;
  reg collision;

  initial begin
    state = 000;
    collision = 0;
    counter = 0;
    reset2 <= 1;
  end
  always @ (posedge clk)
    begin
    c_state <= dir;
    counter <= counter + 1;
    if (counter >= 2499999)
      begin
        case (state)
        UP:
        begin
          if (bird_y > 0) begin
            bird_y <= bird_y - 10;
          end
          else begin
            state = RESET;
          end
          if (c_state == UP) begin
            next = UP;
          end
          if (c_state == DOWN) begin
            next = DOWN;
          end
          if (c_state == RESET) begin
            next = RESET;
          end
        end
        DOWN:
        begin
          if (bird_y < 460) begin
            bird_y <= bird_y + 10;
          end
          if (c_state == UP) begin
            next = UP;
          end
          if (c_state == DOWN) begin
            next = DOWN;
          end
          if (c_state == RESET) begin
            next = RESET;
          end
        end
        START:
        begin
          if (c_state == UP) begin
            reset2 <= 0;
            next = UP;
          end
          if (c_state == DOWN) begin
            reset2 <= 0;
            next = DOWN;
          end
          if (c_state == RESET) begin
            next = START;
          end
        end
        RESET:
        begin
          if (dir == RESET) begin
            next = START;
            reset2 <= 1;
          end
          end
        endcase
        if (state != RESET && state != START) begin
          if (pipe1_x < 1) begin
            pipe1_x <= 640;
          end
          else begin
            pipe1_x <= pipe1_x - 5;
          end
          if (pipe2_x < 1) begin
            pipe2_x <= 640;
          end
          else begin
            pipe2_x <= pipe2_x - 5;
          end
          if (pipe3_x < 1) begin
            pipe3_x <= 640;
          end
          else begin
            pipe3_x <= pipe3_x - 5;
          end
        end
        if (state == START) begin
          bird_x = 30;
          bird_y = 230;

          pipe1_x = 300;
          pipe1y_up = 300;

          pipe2_x = 500;
          pipe2y_up = 100;

          pipe3_x = 100;
          pipe3y_up = 200;
        end

        if (bird_y < 1 || bird_y > 459 ||
        ((((bird_x + 20) > pipe1_x && (bird_x + 20) < pipe1_x + 40) || ((bird_x + 20) == pipe1_x) || (bird_x > pipe1_x && bird_x < pipe1_x + 40)) && (((bird_y + 20 < pipe1y_up) || (bird_y + 20 > pipe1y_up + 80)) || ((bird_y < pipe1y_up) || (bird_y > pipe1y_up + 80)))) ||
        ((((bird_x + 20) > pipe2_x && (bird_x + 20) < pipe2_x + 40) || ((bird_x + 20) == pipe2_x) || (bird_x > pipe2_x && bird_x < pipe2_x + 40)) && (((bird_y + 20 < pipe2y_up) || (bird_y + 20 > pipe2y_up + 80)) || ((bird_y < pipe2y_up) || (bird_y > pipe2y_up + 80)))) ||
        ((((bird_x + 20) > pipe3_x && (bird_x + 20) < pipe3_x + 40) || ((bird_x + 20) == pipe3_x) || (bird_x > pipe3_x && bird_x < pipe3_x + 40)) && (((bird_y + 20 < pipe3y_up) || (bird_y + 20 > pipe3y_up + 80)) || ((bird_y < pipe3y_up) || (bird_y > pipe3y_up + 80))))) begin
          next = START;
          reset2 <= 1;
        end
        // if (bird_y < 1 || bird_y > 479 ||
        // ((bird_y < pipe1y_up || bird_y > pipe1y_up+80) && (bird_x+20 > pipe1_x || bird_x+20 < pipe1_x+5)) || ((bird_y+20 > pipe1y_up+80 || bird_y < pipe1y_up) && ((bird_x > pipe1_x && bird_x < pipe1_x+40) || (bird_x+20 > pipe1_x && bird_x+20 < pipe1_x+40))) ||
        // ((bird_y < pipe2y_up || bird_y > pipe2y_up+80) && (bird_x+20 > pipe2_x || bird_x+20 < pipe2_x+5)) || ((bird_y+20 > pipe2y_up+80 || bird_y < pipe2y_up) && ((bird_x > pipe2_x && bird_x < pipe2_x+40) || (bird_x+20 > pipe2_x && bird_x+20 < pipe2_x+40))) ||
        // ((bird_y < pipe3y_up || bird_y > pipe3y_up+80) && (bird_x+20 > pipe3_x || bird_x+20 < pipe3_x+5)) || ((bird_y+20 > pipe3y_up+80 || bird_y < pipe3y_up) && ((bird_x > pipe3_x && bird_x < pipe3_x+40) || (bird_x+20 > pipe3_x && bird_x+20 < pipe3_x+40)))) begin
        //   next = RESET;
        //   reset2 <= 1;
        // end
        state = next;
        counter <= 0;
      end
      
    end
endmodule