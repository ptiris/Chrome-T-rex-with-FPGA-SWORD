`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2024 03:11:52 AM
// Design Name: 
// Module Name: top_tb
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


module top_tb(

    );

    reg clk;
    reg rstn;
    reg JUMP;
    reg DUCK;
    reg [15:0]SW;
    wire BTNX4;
    wire hs,vs;
    wire [3:0]r,g,b;
    wire buzzer;

    Top uut0(
    .clk(clk),
    .rstn(rstn),
    .JUMP(JUMP),
    .DUCK(DUCK),
    .SW(SW),
    .BTNX4(BTNX4),
    .hs(hs),
    .vs(vs),
    .r(r),
    .g(g),
    .b(b),
    .buzzer(buzzer)
  );

  initial begin
    JUMP=0;
    DUCK=0;
    clk=0;
    rstn=0;
    SW[15:0]=0;
    forever begin
        #10;
        clk=~clk;
    end
  end

  initial begin
    SW[15:0]=0;
    #1000;
    SW[3]=1;
    rstn=1;
    SW[0]=1;
    #10000000;
    rstn=0;
    SW[3]=0;
    SW[1]=1;
    JUMP=1;
  end
endmodule
