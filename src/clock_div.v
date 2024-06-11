`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/07/2024 05:37:28 AM
// Design Name:
// Module Name: clock_div
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


module clock_div #(
    parameter NewT = 1
  )(
    input clk,
    output clk_div
  );
  reg [32:0]cnt;
  reg clk_divv;
  initial
  begin
    cnt=32'b0;
    clk_divv=0;
  end
  always @(posedge clk)
  begin
    if(cnt == NewT-1)begin
        cnt<=0;
        clk_divv<=~clk_divv;
    end
    else begin
        cnt<=cnt+1'b1;
        clk_divv<=clk_divv;   //avoid generating latches
    end
  end

  assign clk_div = clk_divv;
endmodule
