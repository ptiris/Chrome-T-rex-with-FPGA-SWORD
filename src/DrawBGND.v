module DrawBGND #(
    parameter initialY = 100
)(
    input clk,
    input rst,
    input [1:0]gamestate,
    input [9:0]xx,
    input [8:0]yy,
    output isemptyBGND,
    output [11:0]rgb_BGND
);


    wire [9:0]x;
    wire [9:0]y;
    assign x=xx;
    assign y=+9'd480-yy;

    localparam GNDH=27;
    localparam GNDW=2400;
    localparam ScreenH = 480;
    localparam ScreenW = 640;
    localparam UnBegin = 2'b00;
    localparam Running = 2'b01;
    localparam Dead = 2'b10;

    reg [12:0]pos1;
    reg [12:0]pos2;

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            pos1<=0;
            pos2<=ScreenW;
        end
        else begin
            case (gamestate)
                UnBegin:begin
                    pos1<=0;
                    pos2<=ScreenW;
                end 
                Running:begin
                    if(pos2 == GNDW)begin
                        pos2 <= 0;
                        pos1 <= pos1 + 1'b1;
                    end 
                    else if(pos1 == GNDW)begin
                        pos1 <= 0;
                        pos2 <= pos2 + 1'b1;
                    end
                    else begin
                        pos1 <= pos1 + 1'b1;
                        pos2 <= pos2 + 1'b1;
                    end
                end

                Dead:begin
                    pos1<=pos1;
                    pos2<=pos2;
                end

                default: begin
                    pos1<=0;
                    pos2<=ScreenW;
                end
            endcase
        end
    end

    wire accurateY ;
    wire [15:0]tot_addr;
    wire [15:0]spo;

    assign accurateY = ((y<=initialY+GNDH-1'b1) && (y>=initialY));
    assign accurateX = ((x<=ScreenW)&&(x>=0));
    assign tot_addr =  accurateY?2400*(initialY+GNDH-1'b1-y)+pos1+x:0;
    dist_mem_gen_0 dmg0 (
        .a(tot_addr),      // input wire [15 : 0] a
        .spo(spo)  // output wire [15 : 0] spo
    );

    assign isemptyBGND = (!accurateY || spo[3:0]!=4'hF );
    assign rgb_BGND = (!accurateY || spo[3:0]!=4'hF )? 12'hFFF:spo[15:4];
endmodule
