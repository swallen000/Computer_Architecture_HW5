//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:     0416001 ���­� 0416225 ��¤�
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemToReg_o,
	Branchtype_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output [1:0]   RegDst_o;
output         Branch_o;
output 			Jump_o; 	
output			MemRead_o;
output			MemWrite_o;
output [1:0]	MemToReg_o;
output [2-1:0]	Branchtype_o;

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [1:0]   RegDst_o;
reg            Branch_o;
reg				Jump_o;
reg 				MemRead_o;
reg 				MemWrite_o;
reg	[1:0]		MemToReg_o;
reg	[2-1:0]  Branchtype_o;
//Parameter
parameter R_type = 6'b000000;
parameter beq = 6'b000100;
parameter bne = 6'b000101;
parameter addi = 6'b001000;
parameter sll = 6'b000000;
parameter sllv = 6'b000000;
parameter lui = 6'b001111;
parameter ori = 6'b001101;
parameter lw=6'b100011;
parameter sw=6'b101011;
parameter jump = 6'b000010;
parameter li = 6'b001111;
parameter ble = 6'b000111;
parameter blt = 6'b000110;
parameter bnez= 6'b000101; 
parameter jal = 6'b000011;
//Main function
always@(*) begin
	if(instr_op_i == R_type) begin
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
		Jump_o = 1'b1;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b0;
		ALU_op_o = 3'b010;
		RegDst_o = 2'b01;
		RegWrite_o = 1'b1;
		Branchtype_o = 2'b00;
		MemToReg_o = 2'b00;
	end 
	else if(instr_op_i == addi) begin
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
		Jump_o = 1'b1;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b1;
		ALU_op_o = 3'b000;
		RegDst_o = 2'b00;
		RegWrite_o = 1'b1;	
		Branchtype_o = 2'b00;
		MemToReg_o = 2'b00;
	end
	else if(instr_op_i == jump)begin
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
		Jump_o = 1'b0;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b0;
		ALU_op_o = 3'b011;
		RegDst_o = 2'b00;
		RegWrite_o = 1'b0;
		Branchtype_o = 2'b00;
		MemToReg_o = 2'b00;
	end
	else if(instr_op_i == jal)begin
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
		Jump_o = 1'b0;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b0;
		ALU_op_o = 3'b100;
		RegDst_o = 2'b10;
		RegWrite_o = 1'b1;
		Branchtype_o = 2'b00;
		MemToReg_o = 2'b11;
	end
	else if(instr_op_i == lw)begin
		MemRead_o = 1'b1;
		MemWrite_o = 1'b0;
		Jump_o = 1'b1;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b1;
		ALU_op_o = 3'b000;
		RegDst_o = 2'b00;
		RegWrite_o = 1'b1;
		Branchtype_o = 2'b00;
		MemToReg_o = 2'b01;
	end
	else if(instr_op_i == sw)begin
		MemRead_o = 1'b0;
		MemWrite_o = 1'b1;
		Jump_o = 1'b1;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b1;
		ALU_op_o = 3'b000;
		RegDst_o = 2'b00;
		RegWrite_o = 1'b0;
		Branchtype_o = 2'b00;
		MemToReg_o = 2'b00;
	end
	else if(instr_op_i == beq) begin
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
		Jump_o = 1'b1;
		Branch_o = 1'b1;
		ALUSrc_o = 1'b0;
		ALU_op_o = 3'b011;
		RegDst_o = 2'b00;
		RegWrite_o = 1'b0;
		Branchtype_o = 2'b00;
		MemToReg_o = 2'b00;
	end	
	else if(instr_op_i == ble) begin
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
		Jump_o = 1'b1;
		Branch_o = 1'b1;
		ALUSrc_o = 1'b0;
		ALU_op_o = 3'b110;
		RegDst_o = 2'b00;
		RegWrite_o = 1'b0;
		Branchtype_o = 2'b01;
		MemToReg_o = 2'b00;
	end	
	else if(instr_op_i == blt) begin
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
		Jump_o = 1'b1;
		Branch_o = 1'b1;
		ALUSrc_o = 1'b0;
		ALU_op_o = 3'b111;
		RegDst_o = 2'b00;
		RegWrite_o = 1'b0;
		Branchtype_o = 2'b10;
		MemToReg_o = 2'b00;
	end	
	else if(instr_op_i == bnez) begin
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
		Jump_o = 1'b1;
		Branch_o = 1'b1;
		ALUSrc_o = 1'b0;
		ALU_op_o = 3'b101;
		RegDst_o = 2'b00;
		RegWrite_o = 1'b0;
		Branchtype_o = 2'b11;
		MemToReg_o = 2'b00;
	end	
	else if(instr_op_i == bne) begin
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
		Jump_o = 1'b1;
		Branch_o = 1'b1;
		ALUSrc_o = 1'b0;
		ALU_op_o = 3'b001;
		RegDst_o = 2'b00;
		RegWrite_o = 1'b0;	
		Branchtype_o = 2'b11;
		MemToReg_o = 2'b00;
	end
	else if(instr_op_i == li) begin
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
		Jump_o = 1'b1;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b1;
		ALU_op_o = 3'b111; 
		RegDst_o = 2'b00;
		RegWrite_o = 1'b1;	
		Branchtype_o = 2'b00;
		MemToReg_o = 2'b10;		
	end
	else if(instr_op_i == ori) begin
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
		Jump_o = 1'b1;
		Branch_o = 1'b0;
		ALUSrc_o = 1'b1;
		ALU_op_o = 3'b110; 
		RegDst_o = 2'b00;
		RegWrite_o = 1'b1;
		Branchtype_o = 2'b00;
		MemToReg_o = 2'b00;
	end
	else begin
		/*MemRead_o = MemRead_o;
		MemWrite_o = MemWrite_o;
		Jump_o = Jump_o;
		Branch_o = Branch_o;
		ALUSrc_o = ALUSrc_o;
		ALU_op_o = ALU_op_o;
		RegDst_o = RegDst_o;
		RegWrite_o = RegWrite_o;	*/
		MemRead_o = 0;
		MemWrite_o = 0;
		Jump_o = 0;
		Branch_o = 0;
		ALUSrc_o = 0;
		ALU_op_o = 0;
		RegDst_o = 0;
		RegWrite_o = 0;
	end
	end
endmodule





                    
                    