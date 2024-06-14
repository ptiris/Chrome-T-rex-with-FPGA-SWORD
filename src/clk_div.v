module clk_div(
    input clk,
    output reg[31:0]clk_div
  );
  initial
  begin
    clk_div=32'b0;
  end
  always @(posedge clk)
  begin
    clk_div<=clk_div+1'b1;
  end
endmodule
