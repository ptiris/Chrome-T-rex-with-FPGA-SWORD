module DinoState(
        input clk,
        input rst,
        input collision,
        input jump,
        output reg [1:0]gamestate
    );

    localparam UnBegin = 2'b00;
    localparam Running = 2'b01;
    localparam Dead = 2'b10;

    always @(posedge clk or posedge rst) begin
        case (gamestate)
        UnBegin: begin
            if(rst)
                gamestate<=UnBegin;
            else if(jump)
                gamestate<=Running;
        end

        Running: begin
            if(rst)
                gamestate<=UnBegin;
            else if(collision)
                gamestate<=Dead;
            else 
                gamestate<=Running;
        end

        Dead: begin
            if(rst)
                gamestate<=UnBegin;
            else 
                gamestate<=Dead; 
        end
        default:
            gamestate<=UnBegin;
        endcase
    end
endmodule
