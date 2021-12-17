// Code your design here
module TopLevelModule(
  input clk, //clk_div input that we generated in our previous lab to manipulate the frequency to be manageable by the FPGA
  input kb_clk,
  input kb_data,
  input start,
  output h_sync,
  output v_sync,
  output [3:0] red, // 3 RGB inputs which can be manipulated to create any color on screen.
  output [3:0] blue,
  output [3:0] green,
  output [2:0] dir,
  output [3:0] an_act,
  output [6:0] LED
);
  wire clk_d, trig_v, video_on;
  wire [9:0] h_count, v_count, x_loc, y_loc; //we define multiple wires to connect our modules in our Top level module
  wire [2:0] state;
  wire [9:0] bird_x, bird_y;
  wire [9:0] pipe1_x, pipe2_x, pipe3_x, pipe1_y, pipe2_y, pipe3_y;
  wire reset, reset2;
  clk_div c(clk, clk_d);
  h_counter h(clk_d, h_count, trig_v);
  v_counter v(clk_d, trig_v, v_count);
  vga_sync vga(h_count, v_count, h_sync, v_sync, video_on, x_loc, y_loc);
  
  keyboard kb(clk, kb_clk, kb_data, dir, reset);
  mover mov(clk_d, dir, reset2, bird_x, bird_y, pipe1_x, pipe1_y, pipe2_x, pipe2_y, pipe3_x, pipe3_y);
  score s(clk, reset2, an_act, LED);
  pixel_gen pixel(x_loc, y_loc, clk_d, start, video_on, bird_x, bird_y, pipe1_x, pipe1_y, pipe2_x, pipe2_y, pipe3_x, pipe3_y, red, blue, green); //here we call each module and connect it with each other using our pre defined wires and then eventually take the output out.
endmodule