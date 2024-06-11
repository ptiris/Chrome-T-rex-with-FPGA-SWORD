`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2024 03:49:05 PM
// Design Name: 
// Module Name: ObstacleJudge
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


module ObstacleJudge(
        input [9:0]x,
        input [9:0]y,
        input [9:0]ObstacleX,
        input [9:0]ObstacleY,
        input [3:0]ObstacleSEL,
        input animateclk,
        output isemptyObstacle,
        output [11:0]rgb_Obstacle
    );
    localparam ScreenH = 9'd480;
    localparam ScreenW = 10'd640;
    localparam ObstacleWidth1S = 34;
    localparam ObstacleWidth2S = 68;
    localparam ObstacleWidth1B = 50;
    localparam ObstacleWidth2B = 100;
    localparam ObstacleWidthBd = 92;

    localparam ObstacleHeightS = 70;
    localparam ObstacleHeightB = 100;
    localparam ObstacleHeightBd = 80;

    localparam Bird = 4'b1000;
    localparam Cac1S = 4'b0100;//one small cactaceae
    localparam Cac1B = 4'b0101;//one big cactaceae
    localparam Cac2S = 4'b0110;//two small cactaceae
    localparam Cac2B = 4'b0111;//two big cactaceae
    localparam BirdOffset = 70;

    logic [11:0]totaddr_Cac1S;assign totaddr_Cac1S = x - ObstacleX + (ObstacleHeightS + ObstacleY - y -1'b1)*ObstacleWidth1S;
    logic [12:0]totaddr_Cac2S;assign totaddr_Cac2S = x - ObstacleX + (ObstacleHeightS + ObstacleY - y -1'b1)*ObstacleWidth2S;
    logic [12:0]totaddr_Cac1B;assign totaddr_Cac1B = x - ObstacleX + (ObstacleHeightB + ObstacleY - y -1'b1)*ObstacleWidth1B;
    logic [13:0]totaddr_Cac2B;assign totaddr_Cac2B = x - ObstacleX + (ObstacleHeightB + ObstacleY - y -1'b1)*ObstacleWidth2B;
    logic [12:0]totaddr_Bird;assign totaddr_Bird   = x - ObstacleX + (ObstacleHeightBd + ObstacleY + BirdOffset - y -1'b1)*ObstacleWidthBd;

    logic [15:0]rgb_Cac1S,rgb_Cac2S,rgb_Cac1B,rgb_Cac2B,rgb_BirdUp,rgb_BirdDown;
    
    dist_mem_gen_7 dmg7 (
        .a(totaddr_Cac1S),      // input wire [11 : 0] a
        .spo(rgb_Cac1S)  // output wire [15 : 0] spo
    );

    dist_mem_gen_8 dmg8 (
        .a(totaddr_Cac2S),      // input wire [11 : 0] a
        .spo(rgb_Cac2S)  // output wire [15 : 0] spo
    );
    dist_mem_gen_9 dmg9 (
        .a(totaddr_Cac1B),      // input wire [11 : 0] a
        .spo(rgb_Cac1B)  // output wire [15 : 0] spo
    );
    dist_mem_gen_10 dmg10 (
        .a(totaddr_Cac2B),      // input wire [11 : 0] a
        .spo(rgb_Cac2B)  // output wire [15 : 0] spo
    );
    dist_mem_gen_11 dmg11 (
        .a(totaddr_Bird),      // input wire [12 : 0] a
        .spo(rgb_BirdUp)  // output wire [15 : 0] spo
    );
    dist_mem_gen_12 dmg12 (
        .a(totaddr_Bird),      // input wire [12 : 0] a
        .spo(rgb_BirdDown)  // output wire [15 : 0] spo
    );

    logic [15:0] rgb_Obstacle_FULL;

    logic accurateX;
    logic accurateY;

    always_comb begin 
        case (ObstacleSEL)
            Cac1S:begin
                accurateX = ((x>=ObstacleX)&&(x>=0)&&(x<=ScreenW)&&(x<=ObstacleX+ObstacleWidth1S));
                accurateY = ((y>=ObstacleY)&&(y<=ObstacleY+ObstacleHeightS));
                rgb_Obstacle_FULL = rgb_Cac1S;
            end 
            Cac2S:
            begin
                accurateX = ((x>=ObstacleX)&&(x>=0)&&(x<=ScreenW)&&(x<=ObstacleX+ObstacleWidth2S));
                accurateY = ((y>=ObstacleY)&&(y<=ObstacleY+ObstacleHeightS));
                rgb_Obstacle_FULL = rgb_Cac2S;
            end
            Cac1B:
            begin
                accurateX = ((x>=ObstacleX)&&(x>=0)&&(x<=ScreenW)&&(x<=ObstacleX+ObstacleWidth1B));
                accurateY = ((y>=ObstacleY)&&(y<=ObstacleY+ObstacleHeightB));
                rgb_Obstacle_FULL = rgb_Cac1B;
            end
            Cac2B:
            begin
                accurateX = ((x>=ObstacleX)&&(x>=0)&&(x<=ScreenW)&&(x<=ObstacleX+ObstacleWidth2B));
                accurateY = ((y>=ObstacleY)&&(y<=ObstacleY+ObstacleHeightB));
                rgb_Obstacle_FULL = rgb_Cac2B;
            end
            Bird:begin
                accurateX = ((y>=ObstacleY+BirdOffset)&&(y<=ObstacleY+ObstacleHeightB+BirdOffset));
                accurateY = ((x>=ObstacleX)&&(x>=0)&&(x<=ScreenW)&&(x<=ObstacleX+ObstacleWidthBd));
                if(animateclk)begin
                    rgb_Obstacle_FULL = rgb_BirdUp;
                end
                else rgb_Obstacle_FULL = rgb_BirdDown;
            end
            default: begin
                accurateX = ((x>=ObstacleX)&&(x>=0)&&(x<=ScreenW)&&(x<=ObstacleX+ObstacleWidth2B));
                rgb_Obstacle_FULL = rgb_Cac1S;
            end
        endcase
        
    end
    
    assign isemptyObstacle = (~(accurateX && accurateY)) || (rgb_Obstacle_FULL[3:0]!=4'hF);
    assign rgb_Obstacle = rgb_Obstacle_FULL[15:4];
endmodule
