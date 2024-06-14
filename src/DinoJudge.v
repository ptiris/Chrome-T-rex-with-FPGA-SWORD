module DinoJudge(
    input clk,
    input rst,
    input [9:0]x,
    input [9:0]y,
    input [9:0]DinoX,
    input [8:0]DinoY,
    input [3:0]AnimateSel,
    output logic isemptyDino,
    output logic [11:0]rgb_Dino
  );
  localparam DinoWidth = 88;
  localparam DinoHeight = 94;
  localparam DinoDuckWidth = 118;
  localparam DinoDuckHeight = 60;

  logic acurateYR,acurateXR,acurateXD,acurateYD;  //the valid data for different kind of animate.X and Y for X address and Y address.R for running state , D for ducking state.
  logic [13:0]totaddrRun;
  assign totaddrRun = (x-DinoX)+(DinoY+DinoHeight-y-1'b1)*DinoWidth;  //caculate the ROM addr for running state.
  logic [12:0]totaddrDuck ;
  assign totaddrDuck = (x-DinoX)+(DinoY+DinoDuckHeight-y-1'b1)*DinoDuckWidth;//caculate the ROM addr for rucking state.

  logic [15:0]rgb_Run_Dead;
  logic [15:0]rgb_Run_Default;
  logic [15:0]rgb_Run_Left;
  logic [15:0]rgb_Run_Right;
  logic [15:0]rgb_Duck_Left;
  logic [15:0]rgb_Duck_Right;

  localparam DinoDefault = 4'b0000;
  localparam DinoDuckL = 4'b0010;
  localparam DinoDuckR = 4'b1011;
  localparam DinoDead = 4'b0001;
  localparam DinoRunL = 4'b0011;
  localparam DinoRunR = 4'b0111;
//////////////READING DATA FROM ROM//////////////
  dist_mem_gen_1 dmg1 (
                   .a(totaddrRun), // input wire [13 : 0] a
                   .spo(rgb_Run_Dead)   // output wire [15 : 0] spo
                 );

  dist_mem_gen_2 dmg2 (
                   .a(totaddrRun), // input wire [13 : 0] a
                   .spo(rgb_Run_Default)   // output wire [15 : 0] spo
                 );

  dist_mem_gen_3 dmg3 (
                   .a(totaddrRun), // input wire [13 : 0] a
                   .spo(rgb_Run_Left)   // output wire [15 : 0] spo
                 );

  dist_mem_gen_4 dmg4 (
                   .a(totaddrRun), // input wire [13 : 0] a
                   .spo(rgb_Run_Right)   // output wire [15 : 0] spo
                 );

  dist_mem_gen_5 dmg5 (
                   .a(totaddrDuck), // input wire [12 : 0] a
                   .spo(rgb_Duck_Left)   // output wire [15 : 0] spo
                 );

  dist_mem_gen_6 dmg6 (
                   .a(totaddrDuck), // input wire [12 : 0] a
                   .spo(rgb_Duck_Right)   // output wire [15 : 0] spo
                 );
///////////////CHECKING IF IT IS VALID///////////////
  assign  acurateYR = (y>=DinoY)&&(y<=(DinoY+DinoHeight));
  assign  acurateXR = (x>=DinoX)&&(x<=(DinoX+DinoWidth));
  assign  acurateYD = (y>=DinoY)&&(y<=(DinoY+DinoDuckHeight));
  assign  acurateXD = (x>=DinoX)&&(x<=(DinoX+DinoDuckWidth));

  //Full is for RGB plus Alpha data
  //part is only Alpha data
  //desinging like these is only because always_comb block do not support part select
  logic [15:0]rgb_Dino_Full;
  logic [3:0]rgb_Run_Dead_part;
  logic [3:0]rgb_Run_Default_part;
  logic [3:0]rgb_Run_Left_part;
  logic [3:0]rgb_Run_Right_part;
  logic [3:0]rgb_Duck_Left_part;
  logic [3:0]rgb_Duck_Right_part;

  assign rgb_Run_Dead_part    = rgb_Run_Dead[3:0];
  assign rgb_Run_Default_part = rgb_Run_Default[3:0];
  assign rgb_Run_Left_part    = rgb_Run_Left[3:0];
  assign rgb_Run_Right_part   = rgb_Run_Right[3:0];
  assign rgb_Duck_Left_part   = rgb_Duck_Left[3:0];
  assign rgb_Duck_Right_part  = rgb_Duck_Right[3:0];
  
// selecting the rgb and valid data according to Anime state
  always_comb begin
    case (AnimateSel)
      DinoDefault:
      begin
        isemptyDino = (~(acurateXR & acurateYR)) || (rgb_Run_Default_part!=4'hF);
        rgb_Dino_Full = rgb_Run_Default;
      end
      DinoDead:
      begin
        isemptyDino = (~(acurateXR & acurateYR)) || (rgb_Run_Dead_part!=4'hF);
        rgb_Dino_Full = rgb_Run_Dead;
      end

      DinoRunL:
      begin
        isemptyDino = (~(acurateXR & acurateYR)) || (rgb_Run_Left_part!=4'hF);
        rgb_Dino_Full = rgb_Run_Left;
      end

      DinoRunR:
      begin
        isemptyDino = (~(acurateXR & acurateYR)) || (rgb_Run_Right_part!=4'hF);
        rgb_Dino_Full = rgb_Run_Right;
      end

      DinoDuckL:
      begin
        isemptyDino = (~(acurateXD & acurateYD)) || (rgb_Duck_Left_part!=4'hF);
        rgb_Dino_Full = rgb_Duck_Left;
      end

      DinoDuckR:
      begin
        isemptyDino = (~(acurateXD & acurateYD)) || (rgb_Duck_Right_part!=4'hF);
        rgb_Dino_Full = rgb_Duck_Right;
      end

    default:
    begin
      isemptyDino = (~(acurateXR & acurateYR)) || (rgb_Run_Default_part!=4'hF);
      rgb_Dino_Full = rgb_Run_Default;
    end
  endcase
end
  assign rgb_Dino = rgb_Dino_Full[15:4];
endmodule
