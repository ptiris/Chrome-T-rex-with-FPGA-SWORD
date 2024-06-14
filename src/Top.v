module Top(
    output [7:0]SEGMENT,
    output [3:0]AN,
    input ps2_data,         //ps2_data
    input ps2_clk,          //ps2_clk
    input clk,
    input rstn,
    input JUMP,
    input DUCK,
    input [15:0]SW,
    input BTNX4,
    output hs,
    output vs,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b,
    output buzzer,
    output [4:0]LED
  );

  localparam ScreenH = 9'd480;
  localparam ScreenW = 10'd640;

  //////////////////CLOCKS////////////////////
  wire pclk;                  //clock for VGA scan 25Hz
  wire animateclk;            //clock for animation of dino and bird
  wire scoreclk;              //clock for score borad scanning
  wire refreshclk;            //clock for refreshing of VGA
  wire bgndclk;               //clock for moving of background
  wire obsclk;

  wire [31:0]cclk;
  clk_div clkd0(
    .clk(clk),
    .clk_div(cclk)
  );
  assign pclk = cclk[1];
  
  clock_div  #(
    12500000
  )clkd1(
    .clk(clk),
    .clk_div(animateclk)
  );

  clock_div_ref clkd2(
    .row_addr(row_addr),
    .col_addr(col_addr),
    .clk(clk),
    .clk_div(refreshclk)
  );

  clock_div  #(
    100000
  )clkd3(
    .clk(clk),
    .clk_div(bgndclk)
  );

  clock_div  #(
    200000000
  )clkd4(
    .clk(clk),
    .clk_div(obsclk)
  );

  clock_div  #(
    5000000
  )clkd5(
    .clk(clk),
    .clk_div(scoreclk)
  );


  ////////////////////////////////BOTTOMS/////////////////////////////////
  wire rst;
  AntiJitter  #(8) ant0 (
    .clk(clk),
    .SIGNAL(enter),
    .AntiJitter_SIGNAL(rst)
  );

  wire jump;
  AntiJitter  #(8) ant1 (
    .clk(clk),
    .SIGNAL(up||space),
    .AntiJitter_SIGNAL(jump)
  );

  wire duck;
  AntiJitter  #(8) ant2 (
    .clk(clk),
    .SIGNAL(down),
    .AntiJitter_SIGNAL(duck)
  );

  wire up,space,down,enter;
  PS2  PS2_inst (
    .clk(clk),
    .rst(SW[4]),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .up(up),
    .space(space),
    .down(down),
    .enter(enter)
  );

  assign LED[4:2]={jump,duck,rst};  

  //state of the game
  wire [1:0]gamestate;
  DinoState dss0(
    .clk(clk),
    .rst(rst),
    .gamestate(gamestate),
    .collision(collision),
    .jump(jump)
  );

  assign LED[1:0]=gamestate;
  
///////////////Virsual Processing///////////////
  wire [9:0] col_addr;
  wire [8:0] row_addr;

  wire isemptyBGND;
  wire [11:0]rgb_BGND;
  DrawBGND  #(
  )dbg0(
    .clk(bgndclk),
    .rst(rst),
    .gamestate(gamestate),
    .xx(col_addr),
    .yy(row_addr),
    .isemptyBGND(isemptyBGND),
    .rgb_BGND(rgb_BGND)
  );

  wire [11:0]rgb_Dino;
  wire isemptyDino;
  wire [3:0]ANISEL;
  DrawDino #(

  )ddo0(
    .clk(clk),
    .animateclk(animateclk),
    .refreshclk(refreshclk),
    .rst(rst),
    .gamestate(gamestate),
    .xx(col_addr),
    .yy(row_addr),
    .jump(jump),
    .lying(duck),
    .isemptyDino(isemptyDino),
    .rgb_Dino(rgb_Dino),
    .ANISEL(ANISEL)
  );

  wire [11:0]rgb_Obstacle;
  wire isemptyObstacle;
  wire [3:0]OBSSEL;
  DrawObstacle # (  
  )
  
  DrawObstacle_inst (
    .clk(clk),
    .bgndclk(bgndclk),
    .obsclk(obsclk),
    .animateclk(animateclk),
    .refreshclk(refreshclk),
    .rst(rst),
    .gamestate(gamestate),
    .xx(col_addr),
    .yy(row_addr),
    .isemptyObstacle(isemptyObstacle),
    .rgb_Obstacle(rgb_Obstacle),
    .OBSSEL(OBSSEL)
  );

  wire isemptyGameRestart;
  wire [11:0]rgb_GameRestart;
  DrawGameRestart  DrawGameRestart_inst (
    .clk(bgndclk),
    .gamestate(gamestate),
    .xx(col_addr),
    .yy(row_addr),
    .isemptyGameRestart(isemptyGameRestart),
    .rgb_GameRestart(rgb_GameRestart)
  );


  // wire [31:0]clk_div;
  // clock_div clk0(.clk(clk),.clk_div(clk_div));
  assign buzzer = 1'b1;
  assign BTNX4 = 1'b0;
  reg [11:0] vga_data;
  vgac vga0 (
         .vga_clk(pclk), .clrn(SW[0]), .d_in(vga_data), .row_addr(row_addr), .col_addr(col_addr), .r(r), .g(g), .b(b), .hs(hs), .vs(vs)
       );
/////////////COLLISION DETECTION/////////////
  reg collision=0;              //signal for collision
  always @(*) begin
    if(rst)begin
      collision<=0;
    end
    else if((!isemptyDino)&&(!isemptyObstacle))begin
      collision<=1;
    end
    else begin
      collision<=collision;
    end
  end

/////////////Color Painting/////////////
  always @(*) begin
    if(!isemptyDino)begin
      vga_data<=rgb_Dino;
    end
    else if(!isemptyObstacle)begin
      vga_data<=rgb_Obstacle;
    end   
    else if(!isemptyGameRestart)begin
      vga_data<=rgb_GameRestart;
    end
    else begin
      vga_data<=rgb_BGND;
    end
  end

endmodule

 
//dist_mem_gen_0 BKG
//dist_mem_gen_1 DinoDead
//dist_mem_gen_2 DinoDefault
//dist_mem_gen_3 DinoLeft
//dist_mem_gen_4 DinoRight
//dist_mem_gen_5 DinoDuckRight
//dist_mem_gen_6 DinoDuckLeft
//dist_mem_gen_7 Cac1S
//dist_mem_gen_8 Cac2S
//dist_mem_gen_9 Cac1B
//dist_mem_gen_10 Cac2B
//dist_mem_gen_11 BirdUp
//dist_mem_gen_12 BirdDown


/*--------------------------BUGS-----------------------
1.cac disappear when DEAD                   [FIXED]
2.cac disappear when edge of screen         
3.type of obstacle unchange                 [FIXED]
4.ducking of dino bug                       [FIXED]
5.unusual gravation                         [TO BE ADJUSTING]
*/


/*--------------------------FEAT-----------------------
1.Adding of Bird                            [FIXED]
*/