`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 10:39:05 PM
// Design Name: 
// Module Name: clock_div_ref
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


module clock_div_ref(
    input clk,
    input wire [9:0] col_addr,
    input wire [8:0] row_addr,
    output reg clk_div
    );
    reg [8:0]la_row;
    initial begin
        clk_div = 0;
    end
    always @(posedge clk) begin
        if(row_addr == 9'd511 && la_row!=9'd511)begin
            clk_div<=~clk_div;
            la_row<=9'd511;
        end
        else begin
            clk_div<=clk_div;
            la_row<=row_addr;
        end
    end
endmodule
