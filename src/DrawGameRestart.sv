module DrawGameRestart(
        input clk,
        input [1:0]gamestate,
        input [9:0]xx,
        input [8:0]yy,
        output logic isemptyGameRestart,
        output logic [11:0]rgb_GameRestart
    );

    logic [9:0]x;
    logic [9:0]y;
    assign x=xx;
    assign y=9'd480-yy;
    localparam initialX = 284;
    localparam initialY = 200;
    localparam Width = 72;
    localparam Height = 64;

    logic accurateX;assign  accurateX= (x>=initialX)&&(x<=initialX+Width);
    logic accurateY;assign accurateY = (y>=initialY)&&(y<=initialY+Height);
    logic [15:0]rgb_GameRestart_FULL;

    dist_mem_gen_13 dmg13 (
        .a(totaddr_Restart),      // input wire [12 : 0] a
        .spo(rgb_GameRestart_FULL)  // output wire [15 : 0] spo
    );

    logic [12:0]totaddr_Restart;
    assign totaddr_Restart = x - initialX + (Height + initialY - y -1'b1)*Width;

    assign isemptyGameRestart = ((!(accurateX && accurateY)) || (rgb_GameRestart_FULL[3:0]!=4'hF)) || (gamestate != 2'b10);
    assign rgb_GameRestart = rgb_GameRestart_FULL[15:4];   

endmodule
