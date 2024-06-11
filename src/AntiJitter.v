`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/20/2024 09:47:14 PM
// Design Name:
// Module Name: AntiJitter
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


module AntiJitter #(parameter Peroids = 8)(
    input clk,
    input SIGNAL,
    output AntiJitter_SIGNAL
  );
  reg [7:0]cnt = 0;

  always @(posedge clk)
  begin
    cnt<={cnt[6:0],SIGNAL};
  end
  assign AntiJitter_SIGNAL=&cnt;
endmodule
