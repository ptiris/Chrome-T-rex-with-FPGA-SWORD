module ObstacleFSM(
        input rst,
        input [1:0]gamestate,
        input animateclk,
        input ObstacleRunning,
        output logic [9:0]FinalWidth,
        output logic [3:0]ObstacleSEL,
        output reg BirdSEL
    );
    localparam Bird = 4'b1000;
    localparam Cac1S = 4'b0100;     //one small cactaceae
    localparam Cac1B = 4'b0101;     //one big cactaceae
    localparam Cac2S = 4'b0110;     //two small cactaceae
    localparam Cac2B = 4'b0111;     //two big cactaceae

    localparam UnBegin = 2'b00;
    localparam Running = 2'b01;
    localparam Dead = 2'b11;    

    localparam ObstacleWidthS = 50;
    localparam ObstacleWidthM = 100;
    localparam ObstacleWidthB = 150;

    localparam ObstacleHeightS = 70;
    localparam ObstacleHeightB = 100;

    logic [3:0]ObstacleSEL_TMP;

    always @(posedge rst or posedge ObstacleRunning) begin
        if(rst)begin                  //set the animate type to default
            ObstacleSEL_TMP<=Cac2B;
            FinalWidth<=ObstacleWidthM;
        end
        else begin
            case (gamestate)
                UnBegin: begin          //set the animate type to default and stay the same
                    ObstacleSEL_TMP <= ObstacleSEL;
                end 
                Running: begin
                    case (ObstacleSEL)      //change between diffrent types
                        Cac1S:begin ObstacleSEL_TMP <= Cac2B; FinalWidth<=9'd100;end
                        Cac2B:begin ObstacleSEL_TMP <= Cac1B; FinalWidth<=9'd50 ;end
                        Cac1B:begin ObstacleSEL_TMP <= Bird; FinalWidth<=9'd92;end
                        Bird:begin ObstacleSEL_TMP <= Cac2S; FinalWidth<=9'd68;end
                        Cac2S:begin ObstacleSEL_TMP <= Cac1S; FinalWidth<=9'd34;end
                        default: begin ObstacleSEL_TMP <= Cac2B; FinalWidth<=9'd100;end
                    endcase
                end
                Dead: begin         //stay the same when dead
                    ObstacleSEL_TMP <= ObstacleSEL;
                    FinalWidth<=FinalWidth;
                end
                default: begin ObstacleSEL_TMP <= Cac2B; FinalWidth<=9'd100;end
            endcase
        end

    end
    //change the animate of bird according to animateclk
    initial begin
        BirdSEL<=1'b1;
    end

    always @(posedge animateclk or posedge rst) begin
        if(rst)begin
            BirdSEL<=1'b1;
        end
        else if(gamestate==Running)begin
            BirdSEL<=~BirdSEL;
        end
        else begin
            BirdSEL<=BirdSEL;
        end
    end
    assign ObstacleSEL=ObstacleSEL_TMP;
endmodule

