`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2024 07:41:02 PM
// Design Name: 
// Module Name: PrintColor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PrintColor2VGA(
        input wire clka,
        input wire [9:0]row_addr,
        input wire [8:0]col_addr,
        output reg [11:0]vga_data
    );
    wire [14:0]tot_addr;
    wire [11:0]spo;

    assign tot_addr = (row_addr>>2)*160+(col_addr>>2);
    dist_mem_gen_0 dmg0 (
        .we(0),
        .clka(clka),
        .a(tot_addr),      // input wire [14 : 0] a
        .spo(spo)  // output wire [11 : 0] spo  
      );

    always @(*) begin
        vga_data<=spo;
    end
endmodule

module PrintColor2MAP (
    
);
    
endmodule
