// Code your design here
module pixel_gen3(

  input [9:0] pixel_x,
  input [9:0] pixel_y,

  input clk_div,
  input start,
  input video_on,
  input [9:0] bird_x,
  input [9:0] bird_y,

  input [9:0] pipe1_x,
  input [9:0] pipe1y_up,
  input [9:0] pipe2_x,
  input [9:0] pipe2y_up,
  input [9:0] pipe3_x,
  input [9:0] pipe3y_up,

  output reg [3:0] red = 0,
  output reg [3:0] blue = 0,
  output reg [3:0] green = 0
);

  reg w = 1'b1;
  reg [22:0] counter = 0;
  parameter UP = 3'b010;
  parameter DOWN = 3'b100;
  parameter START = 3'b000;
  parameter RESET = 3'b111;
  always @ (posedge clk_div && start)
    begin
      if ((pixel_y >= 80 && pixel_y <= 400) && (pixel_x >= 100 && pixel_x <= 540))
//        drawing a box
        begin
          red <= 4'hf;
          blue <= 4'hf;
          green <= 4'hf;
        end
    end
      
endmodule