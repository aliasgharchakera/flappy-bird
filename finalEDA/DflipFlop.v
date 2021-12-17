// Code your design here
module DFF(D,clk,Q);
  input D; // Data input 
  input clk; // clock input 
  output reg Q; // output Q 
  always @(posedge clk) begin
   Q <= D; 
  end
endmodule