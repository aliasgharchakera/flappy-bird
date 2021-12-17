// Code your design here

module h_counter(clk, h_count, trig_v);
  input clk;
  output trig_v;
  output [9:0] h_count;
  // we use register for both our outputs as they eventually will be changed
  reg trig_v;
  reg [9:0] h_count;
  initial
    begin
      h_count <= 0; trig_v <= 1'b0;
    end
    always @ (posedge clk)
    begin
      if (h_count <= 798)
        begin
          if (h_count == 798)
            begin
              trig_v <= 1'b1;
            end
          h_count <= h_count + 1;
        end
      else
        begin
          h_count <= 0;
          trig_v <= 1'b0;
        end
    end
endmodule
