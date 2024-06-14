module counter10_4 (
    input clk, rst,
    input running,
    output [15:0] cnt
);
    wire [3:0] run;
    assign run[0] = running;
    assign run[1] = (cnt[3:0] == 4'h9)? 1'b1 : 1'b0;
    assign run[2] = (cnt[7:0] == 8'h99)? 1'b1 : 1'b0;
    assign run[3] = (cnt[11:0] == 12'h999)? 1'b1 : 1'b0;
    counter10 cnt0(.clk(clk), .rst(rst), .running(run[0]), .cnt(cnt[3:0]), .carry_out());
    counter10 cnt1(.clk(clk), .rst(rst), .running(run[1]), .cnt(cnt[7:4]), .carry_out());
    counter10 cnt2(.clk(clk), .rst(rst), .running(run[2]), .cnt(cnt[11:8]), .carry_out());
    counter10 cnt3(.clk(clk), .rst(rst), .running(run[3]), .cnt(cnt[15:12]), .carry_out());
endmodule

module ScoreCounter (
    input scoreclk,
    input rst,
    input [31:0]cclk,
    input [1:0]gamestate,
    output [3:0]AN,
    output [7:0]SEGMENT
);  

    wire [15:0]dispnum;
    counter10_4 cnt1040(
        .clk(scoreclk),
        .rst(rst),
        .running(gamestate==2'b01),
        .cnt(dispnum)
    );

    DispM dsp0(
        .scan(cclk[18:17]),
        .HEXS(dispnum),
        .point(1'b0),
        .LES(1'b0),
        .AN(AN),
        .SEGMENT(SEGMENT)
      );
endmodule