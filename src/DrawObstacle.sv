module DrawObstacle #(parameter initialY = 102)(
        input clk,
        input bgndclk,
        input obsclk,
        input animateclk,
        input refreshclk,
        input rst,
        input [1:0]gamestate,
        input [9:0]xx,
        input [8:0]yy,
        output isemptyObstacle,
        output [11:0]rgb_Obstacle,
        output [3:0]OBSSEL
    );
    logic [9:0]x;
    logic   [9:0] y;
    assign x=xx;
    assign y=9'd480-yy;
///////////parameters settings/////////////
    localparam UnBegin = 2'b00;
    localparam Running = 2'b01;
    localparam Dead = 2'b10;

    localparam ScreenH = 9'd480;
    localparam ScreenW = 10'd640;

    localparam ObstacleWidthS = 50;
    localparam ObstacleWidthM = 100;
    localparam ObstacleWidthB = 150;

    localparam ObstacleHeightS = 70;
    localparam ObstacleHeightB = 100;

    localparam BirdOffset = 60;

    logic [9:0]FinalWidth;      //the final width according to the animate state
    logic [9:0]FinalHeight;     //the final height according to the animate state

    logic signed [10:0]ObstacleX;  
    logic [9:0]ObstacleY;
    logic [3:0]ObstacleSEL;
    logic ObstacleRunning;
    assign OBSSEL = ObstacleSEL;

    logic accurateX;//the validity of X addr
    assign accurateX = (((ObstacleX + FinalWidth) > 0 ) && ( ObstacleX < ScreenW ) );
    assign ObstacleRunning = obsclk | accurateX;   //If generate an obstacle

    ObstacleFSM  obfsm0 (
        .rst(rst),
        .animateclk(animateclk),
        .gamestate(gamestate),
        .ObstacleRunning(ObstacleRunning),
        .ObstacleSEL(ObstacleSEL),
        .FinalWidth(FinalWidth)
      );
    ObstacleJudge  obj0 (
        .x(x),
        .y(y),
        .gamestate(gamestate),
        .ObstacleX(ObstacleX),
        .ObstacleY(ObstacleY),
        .ObstacleSEL(ObstacleSEL),
        .isemptyObstacle(isemptyObstacle),
        .rgb_Obstacle(rgb_Obstacle),
        .animateclk(animateclk)
    );
    always @(posedge bgndclk or posedge rst) begin
        if(rst)begin                        //reset the obstacle out of screen by adding an offset of ObstacleWidthS
            ObstacleX<=ScreenW + ObstacleWidthS;
            ObstacleY<=initialY;
        end
        else begin
            case (gamestate)
                UnBegin: begin
                    ObstacleX <= ScreenW + ObstacleWidthS;   //reset the obstacle out of screen by adding an offset of ObstacleWidthS
                    ObstacleY <= initialY;
                end
                Running:begin
                    if(ObstacleRunning || accurateX)begin  //in running state obstacle begin moving with backgound
                        ObstacleX <= ObstacleX-1'b1;
                        ObstacleY <= ObstacleY;
                    end
                    else begin
                        ObstacleX <= ScreenW;
                        ObstacleY <= ObstacleY;
                    end
                end
                Dead:begin                              // in the dead state obstale stay the same
                    ObstacleX <= ObstacleX;
                    ObstacleY <= ObstacleY;
                end
                default: begin
                    ObstacleX <= ScreenW + ObstacleWidthS;
                    ObstacleY <= initialY;
                end
            endcase
        end
    end
endmodule
