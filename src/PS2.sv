module PS2(
	input clk, rst,
	input ps2_clk, ps2_data,
	output reg up, space, down, enter
	);

reg ps2_clk_flag0, ps2_clk_flag1, ps2_clk_flag2;
wire negedge_ps2_clk = !ps2_clk_flag1 & ps2_clk_flag2;
reg negedge_ps2_clk_shift;
reg [9:0] data;
reg data_break,data_expand;
reg[7:0]temp_data;
reg[3:0]num;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		ps2_clk_flag0 <= 1'b0;
		ps2_clk_flag1 <= 1'b0;
		ps2_clk_flag2 <= 1'b0;
	end
	else begin
		ps2_clk_flag0 <= ps2_clk;
		ps2_clk_flag1 <= ps2_clk_flag0;
		ps2_clk_flag2 <= ps2_clk_flag1;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)
		num <= 4'd0;
	else if (num==4'd11)
		num <= 4'd0;
	else if (negedge_ps2_clk)
		num <= num+1'b1;
end

always@(posedge clk)begin
	negedge_ps2_clk_shift <= negedge_ps2_clk;
end


always@(posedge clk or posedge rst)begin
	if(rst)
		temp_data <= 8'd0;
	else if (negedge_ps2_clk_shift)begin
		case(num)
			4'd2 : temp_data[0] <= ps2_data;
			4'd3 : temp_data[1] <= ps2_data;
			4'd4 : temp_data[2] <= ps2_data;
			4'd5 : temp_data[3] <= ps2_data;
			4'd6 : temp_data[4] <= ps2_data;
			4'd7 : temp_data[5] <= ps2_data;
			4'd8 : temp_data[6] <= ps2_data;
			4'd9 : temp_data[7] <= ps2_data;
			default: temp_data <= temp_data;
		endcase
	end
	else temp_data <= temp_data;
end

always@(posedge clk or posedge rst)begin
	if(rst)begin
		data_break <= 1'b0;
		data <= 10'd0;
		data_expand <= 1'b0;
	end
	else if(num==4'd11)begin
		if(temp_data==8'hE0)begin
			data_expand <= 1'b1;
		end
		else if(temp_data==8'hF0)begin
			data_break <= 1'b1;
		end
		else begin
			data <= {data_expand,data_break,temp_data};
			data_expand <= 1'b0;
			data_break <= 1'b0;
		end
	end
	else begin
		data <= data;
		data_expand <= data_expand;
		data_break <= data_break;
	end
end

always @(posedge clk) begin
	case (data)
        10'h05A:enter <= 1'b1;
        10'h15A:enter <= 1'b0;
        10'h275:up <= 1'b1;
        10'h375:up <= 1'b0;
        10'h029:space <= 1'b1;
        10'h129:space <= 1'b0;
        10'h272:down <= 1'b1;
        10'h372:down <= 1'b0;
    endcase
end
endmodule