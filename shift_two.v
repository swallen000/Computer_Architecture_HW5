`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 0416001 ¿àÝÂ­Û 0416225 ¿à«Â¤¯
// 
// Create Date:    23:16:36 05/06/2017 
// Design Name: 
// Module Name:    shift_two 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module shift_two(
		data_i,
		data_o
    );
	 input data_i;
	 output [27:0] data_o;
	 wire [25:0] data_i;
	 wire [27:0] data_o;
	 assign data_o = data_i <<2;


endmodule
