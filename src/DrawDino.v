module DrawDino#(
    parameter initialY = 102,
    parameter initialX = 10
)(
    input clk,
    input animateclk,
    input refreshclk,
    input rst,
    input jump,
    input lying,
    input [1:0]gamestate,
    input [9:0]xx,
    input [8:0]yy,
    output isemptyDino,
    output [11:0]rgb_Dino,
    output [3:0]ANISEL
    );

    wire [9:0]x;
    wire [9:0]y; 
    assign x=xx;
    assign y=+9'd480-yy;

    wire [3:0]AnimateSel;
    reg [9:0]DinoX;
    reg signed [9:0]DinoY;
    reg signed [6:0] VerticalV;
    reg onJumping;
    wire isOnGround;
    wire isDead;
    wire isLying;
    
    localparam UnBegin = 2'b00;
    localparam Running = 2'b01;
    localparam Dead = 2'b10;
    localparam Grav = 4;
    localparam initialV = 7'd40;

    assign isOnGround = (DinoY == initialY);
    assign isDead = (gamestate == 2'b10);
    assign isLying = lying;

    AnimateFSM afsm0(
        .clk(clk),
        .rst(rst),
        .animateclk(animateclk),
        .refreshclk(refreshclk),
        .gamestate(gamestate),
        .Sel(AnimateSel),
        .isOnGround(isOnGround),
        .isLying(isLying)
    );

    DinoJudge dnj0(
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .DinoX(DinoX),
        .DinoY(DinoY),
        .AnimateSel(AnimateSel),
        .isemptyDino(isemptyDino),
        .rgb_Dino(rgb_Dino)
    );

    always @(posedge refreshclk or posedge rst) begin
        if(rst)begin
            DinoY<=initialY;
            DinoX<=initialX;
            VerticalV<=0;
            onJumping<=0;
        end
        else begin
            case (gamestate)
                UnBegin:begin
                    DinoY<=initialY;
                    DinoX<=initialX;
                end 
                Dead: DinoY<=DinoY;
                Running: begin
                    if(onJumping) begin
                        DinoY<=(VerticalV+DinoY);
                        VerticalV<=VerticalV-Grav;
                        if(DinoY==initialY && VerticalV<0)begin
                            onJumping<=0;
                            DinoY<=initialY;
                            VerticalV<=0;
                        end
                    end
                    else if(jump)begin
                        onJumping<=1;
                        VerticalV<=initialV;
                    end
                end
                default: DinoY<=initialY;
            endcase
        end
    end
endmodule
