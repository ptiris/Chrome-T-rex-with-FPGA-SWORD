`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/30/2024 12:57:43 AM
// Design Name:
// Module Name: clk_div
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


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
