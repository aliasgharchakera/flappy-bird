// Code your design here
module v_counter(clk, enable_v, v_count);
  input clk; input enable_v;
  output [9:0] v_count;
  // we use register for both our outputs as they eventually will be changed
  reg [9:0] v_count;
  initial
    v_count <= 0;
    always @ (posedge clk)
    begin
      if (enable_v == 1)
        begin
          if (v_count <= 523)
          	v_count <= v_count + 1;
          else
          	v_count <= 0;
        end
    end
endmodule