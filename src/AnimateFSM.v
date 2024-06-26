module AnimateFSM(
    input clk,
    input rst,
    input animateclk,
    input refreshclk,
    input [1:0]gamestate,
    input isOnGround,
    input isLying,
    output [3:0]Sel
  );

reg [3:0]AnimateSel;

  localparam UnBegin = 2'b00;
  localparam Running = 2'b01;
  localparam Dead = 2'b10;

  localparam DinoDefault = 4'b0000;
  localparam DinoDuckL = 4'b0010;
  localparam DinoDuckR = 4'b1011;
  localparam DinoDead = 4'b0001;
  localparam DinoRunL = 4'b0011;
  localparam DinoRunR = 4'b0111;

  always @(*) begin
    if(rst)begin        //reset to default state
        AnimateSel<=4'b0000;
    end

    else begin
        case (gamestate)
            UnBegin:begin   //reset to default state
                AnimateSel<=DinoDefault;
            end 
            Dead:begin      //when dead ,set to dead state
               AnimateSel<=DinoDead; 
            end
            Running:begin
                if(~isOnGround)     //when jumping ,set to default state
                    AnimateSel<=DinoDefault;
                else if(isLying)begin
                    if(animateclk)   //switching between left and right according to animate clock
                        AnimateSel<=DinoDuckL;
                    else AnimateSel<=DinoDuckR;
                end
                else begin
                    if(animateclk)   //switching between left and right according to animate clock
                        AnimateSel<=DinoRunL;
                    else AnimateSel<=DinoRunR; 
                end
            end
            default: begin
                AnimateSel<=DinoDefault;
            end
        endcase
    end
  end

  assign Sel=AnimateSel;
endmodule
