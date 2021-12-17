module mover2(clk, dir, reset2, bird_x, bird_y, pipe1_x, pipe1y_up, pipe2_x, pipe2y_up, pipe3_x, pipe3y_up);
  input clk;
  //reset;
  input [2:0] dir;
  reg W;
  reg S;
  reg X;
  wire DA, DB, A, B;
  reg clk_d2;
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

  clk_div2 c2(clk, clk2);
  DFF d1(DA, clk2, A);
  DFF d2(DB, clk2, B);

  assign DA = ((A&&B&&(~X))||((~A)&&(~W)&&S&&(~X))||(A&&(~B)&&(~W)&&(~S))||((~A)&&B&&(~W)&&(~S)&&X));
  assign DB = ((W&&(~S)&&(~X))||(A&&B&&(~X))||((~A)&&B&&W&&(~S))||(A&&(~B)&&(~W)&&(~S)&&X));
  assign play = ((~A)&&B || A&&(~B));

  initial begin
    state = 000;
    collision = 0;
    counter = 0;
    reset2 <= 1;
    W = 0;
    S = 0;
    X = 0;
  end
  always @ (posedge clk)
    begin
    c_state <= dir;
    counter <= counter + 1;
    if (counter >= 2499999)
      begin
        if (dir == 010) begin
            W = 1;
            S = 0;
            X = 0;
        end
        if (dir == 100) begin
            W = 0;
            S = 1;
            X = 0;
        end
        if (dir == 111) begin
            W = 0;
            S = 0;
            X = 1;
        end

        if (A && B) begin
            reset2 <= 1;

        end

        if ((~A) && B) begin
            reset2 <= 0;
            if (bird_y > 0) begin
               bird_y <= bird_y - 10; 
            end
        end

        if (A && (~B)) begin
            reset2 <= 0;
            if (bird_y < 460) begin
               bird_y <= bird_y + 10; 
            end
        end

        if ((~A) && (~B)) begin
            reset2 <= 1;
            bird_x = 30;
            bird_y = 230;

            pipe1_x = 300;
            pipe1y_up = 300;

            pipe2_x = 500;
            pipe2y_up = 100;

            pipe3_x = 100;
            pipe3y_up = 200;
        end

        if ((A && (~B)) || ((~A) && B)) begin
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
        if (bird_y < 1 || bird_y > 459 ||
        ((((bird_x + 20) > pipe1_x && (bird_x + 20) < pipe1_x + 40) || ((bird_x + 20) == pipe1_x) || (bird_x > pipe1_x && bird_x < pipe1_x + 40)) && (((bird_y + 20 < pipe1y_up) || (bird_y + 20 > pipe1y_up + 80)) || ((bird_y < pipe1y_up) || (bird_y > pipe1y_up + 80)))) ||
        ((((bird_x + 20) > pipe2_x && (bird_x + 20) < pipe2_x + 40) || ((bird_x + 20) == pipe2_x) || (bird_x > pipe2_x && bird_x < pipe2_x + 40)) && (((bird_y + 20 < pipe2y_up) || (bird_y + 20 > pipe2y_up + 80)) || ((bird_y < pipe2y_up) || (bird_y > pipe2y_up + 80)))) ||
        ((((bird_x + 20) > pipe3_x && (bird_x + 20) < pipe3_x + 40) || ((bird_x + 20) == pipe3_x) || (bird_x > pipe3_x && bird_x < pipe3_x + 40)) && (((bird_y + 20 < pipe3y_up) || (bird_y + 20 > pipe3y_up + 80)) || ((bird_y < pipe3y_up) || (bird_y > pipe3y_up + 80))))) begin
          W = 0; S = 0; X = 1;
          reset2 <= 1;
        end
        state = next;
        counter <= 0;
      end
      
    end
endmodule