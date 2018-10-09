//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:     0416001 ¿àÝÂ­Û 0416225 ¿à«Â¤¯ 
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module CPU(
        clk_i,
		start_i
		);
		
//I/O port
input         clk_i;
input         start_i;

//Internal Signles

//pc signal
wire [31:0] pc_signal_in;
wire [31:0] pc_signal_out;

//adder1 signal
wire [31:0] sum_1;

//shift left two 26
wire [27:0] jump_target;

	
//IM signal
wire [31:0] instr_out;

//MWR signal 
wire [4:0] data_out;


//RF signal
wire [31:0] rsdata_out ;
wire [31:0] rtdata_out ;

//Decoder signal
wire [1:0] regdst_out;
wire regwrite_out;
wire [2:0] ALU_op_out;
wire ALU_src_out;
wire branch_out;
wire MemRead_out;
wire MemWrite_out;
wire [1:0] MemtoReg_out;
wire [1:0] branch_type_out;
wire  jump_out;	

//ALU ctr signal
wire [3:0] ALU_ctr_out;
wire jump_type_out;

//sign extend signal
wire [31:0] sign_extend_out ;

//MuxALUsrc signal
wire [31:0] mux_ALU_out ; 


//ALU signal
wire  [31:0] ALU_result ;
wire zero_out ; 
//adder2 signal
wire [31:0] sum_2 ;

//shift_left_two_32
wire [31:0] shift_out;

//Mux_write_rs
wire [31:0] rs_input;
wire rs_select;

//and signal 
wire and_out;

//pc_source signal
wire [31:0] pc_signal_in_tmp;
wire [31:0] pc_signal_in_tmp1;

//data memory signal
wire [31:0] dMemory_out;

//mux for write back signal	
wire [31:0] wb_out;		
	
//mux signal for branch 	
wire and_i ;	
	
//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	     .rst_i (start_i),     
	     .pc_in_i(pc_signal_in) ,   
	     .pc_out_o(pc_signal_out) 
	    );

////////////////handle jump and pc signal	/////////////
Adder Adder1(
        .src1_i(pc_signal_out),     
	     .src2_i(32'd4),     
	     .sum_o(sum_1)    
			);
		 
Adder Adder2(
        .src1_i(sum_1),     
		  .src2_i(shift_out),     
	     .sum_o(sum_2)      
			);
		 
shift_two shifter1(
	     .data_i(instr_out[25:0]),
	     .data_o(jump_target)
			);

Shift_Left_Two_32 Shifter(
        .data_i(sign_extend_out),
        .data_o(shift_out)
        ); 			

MUX_2to1 #(.size(32)) Mux_jump_type(
			.data0_i(pc_signal_in_tmp1),
			.data1_i(rsdata_out),
			.select_i(jump_type_out),
			.data_o(pc_signal_in)
			);


MUX_2to1 #(.size(32)) Mux_jump(
			.data0_i({sum_1[31:28] , jump_target}),
			.data1_i(pc_signal_in_tmp),
			.select_i(jump_out),
			.data_o(pc_signal_in_tmp1)
        );	

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(sum_1),
        .data1_i(sum_2),
        .select_i(and_out),
		  .data_o(pc_signal_in_tmp)
        );	
///////////////////////////////////////////////////////

///////////IF operation/////////////////
Instruction_Memory IM(
        .addr_i(pc_signal_out),  
	     .instr_o(instr_out)    
	    );

///////////////////////////////////////

MUX_4to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_out[20:16]),
        .data1_i(instr_out[15:11]),
		  .data2_i(5'd31),
		  .data3_i(5'd0),
        .select_i(regdst_out),
        .data_o(data_out)
        );	
		  
Reg_File RF(
        .clk_i(clk_i),      
		  .rst_i(start_i) , 
        .RSaddr_i(instr_out[25:21]) ,  
        .RTaddr_i(instr_out[20:16]) ,  
        .RDaddr_i(data_out) ,  
		  .RDdata_i(wb_out)  , 
        .RegWrite_i (regwrite_out),
        .RSdata_o(rsdata_out) ,  
        .RTdata_o(rtdata_out)   
        );
			  
///////////////handle li//////////////////////		  
MUX_2to1 #(.size(32)) Mux_write_rs(
        .data0_i(rsdata_out),
        .data1_i(sign_extend_out),
        .select_i(rs_select),
        .data_o(rs_input)			
		  );
///////////////////////////////////////////////
		

Decoder Decoder(
        .instr_op_i(instr_out[31:26]), 
	     .RegWrite_o(regwrite_out), 
	     .ALU_op_o(ALU_op_out),   
	     .ALUSrc_o(ALU_src_out),
	     .RegDst_o(regdst_out),   
		  .Branch_o(branch_out),
		  .MemRead_o(MemRead_out),
		  .MemWrite_o(MemWrite_out),
		  .MemToReg_o(MemtoReg_out),
		  .Branchtype_o(branch_type_out),
		  .Jump_o(jump_out)	    
		  );

ALU_Ctrl AC(
        .funct_i(instr_out[5:0]),   
        .ALUOp_i(ALU_op_out),   
        .ALUCtrl_o(ALU_ctr_out),
		  .ALU_o(rs_select),
		  .Jump_type_out(jump_type_out)
        );
	
Sign_Extend SE(
        .data_i(instr_out[15:0]),
        .data_o(sign_extend_out)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(rtdata_out),
        .data1_i(sign_extend_out),
        .select_i(ALU_src_out),
        .data_o(mux_ALU_out)
        );	
		
ALU ALU(
		 .rst_i(start_i),
       .src1_i(rs_input),
	    .src2_i(mux_ALU_out),
	    .ctrl_i(ALU_ctr_out),
	    .result_o(ALU_result),
		.zero_o(zero_out)
	    );
		

	
and g(and_out , and_i , branch_out);

Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(ALU_result),
	.data_i(rtdata_out),
	.MemRead_i(MemRead_out),
	.MemWrite_i(MemWrite_out),
	.data_o(dMemory_out)
);
	
MUX_4to1 #(.size(1)) Mux_beq_bne(
	.data0_i(zero_out),			//beq
	.data1_i(/*zero_out|ALU_result[31]*/zero_out),		//ble
	.data2_i(/*ALU_result[31]*/zero_out),		//blt
	.data3_i(zero_out),		//bne,bnez
	.select_i(branch_type_out),
	.data_o(and_i)
);
	
MUX_4to1 #(.size(32)) Mux_write_back(	
	.data0_i(ALU_result),
	.data1_i(dMemory_out),
	.data2_i(sign_extend_out),
	.data3_i(sum_1),//jal handling
	.select_i(MemtoReg_out),
	.data_o(wb_out)
);

endmodule