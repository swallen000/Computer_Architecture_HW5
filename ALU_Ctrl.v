//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0416001 ���­� 0416225 ��¤�
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
			 ALU_o,
			 Jump_type_out
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
output 	  ALU_o;
output	  Jump_type_out;	
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg 		  ALU_o;
reg		  Jump_type_out;
//Parameter
localparam sll= 6'b000000;
localparam sllv=6'b000100;
localparam add= 6'b100000;
localparam sub= 6'b100010;
localparam AND= 6'b100100;
localparam OR=  6'b100101;
localparam slt= 6'b101010;
localparam sltu=6'b101011;  
localparam mul= 6'b011000;  
localparam jr = 6'b001000;
//Select exact operation
always@(*) begin
	case(ALUOp_i[2:0])
		3'b000:  begin
			ALUCtrl_o=4'b0010;	//lw,sw
			ALU_o=0;
			Jump_type_out = 1'b0;
		end
		3'b001:  begin
			ALUCtrl_o=4'b0110;		//bne
			ALU_o=0;
			Jump_type_out = 1'b0;
		end
		3'b011:	begin
			ALUCtrl_o=4'b1110;		//beq
			ALU_o=0;
			Jump_type_out = 1'b0;
		end
		3'b010:  begin	//r-type0
			case(funct_i)
				sll:  begin
						ALUCtrl_o=4'b1110;
						ALU_o=1;
						Jump_type_out = 1'b0;
				end
				sllv:  begin
						ALUCtrl_o=4'b1110;
						ALU_o=0;
						Jump_type_out = 1'b0;
				end
				add:  begin
					ALUCtrl_o=4'b0010;
					ALU_o=0;
					Jump_type_out = 1'b0;
				end
				sub:  begin
					ALUCtrl_o=4'b0110;
					ALU_o=0;
					Jump_type_out = 1'b0;
				end
				AND: begin
					ALUCtrl_o=4'b0000;
					ALU_o=0;
					Jump_type_out = 1'b0;
				end
				OR:   begin
					ALUCtrl_o=4'b0001;
					ALU_o=0;
					Jump_type_out = 1'b0;
				end
				slt:  begin
					ALUCtrl_o=4'b0111;
					ALU_o=0;
					Jump_type_out = 1'b0;
				end
				sltu: begin
					ALUCtrl_o=4'b1011;
					ALU_o=0;
					Jump_type_out = 1'b0;
				end
				mul: begin
					ALUCtrl_o=4'b1111;
					ALU_o=0;
					Jump_type_out = 1'b0;
				end
				jr: begin
					ALUCtrl_o=4'b1000;		//need check
					ALU_o=0;
					Jump_type_out = 1'b1;
				end
				default: begin
					ALUCtrl_o=4'b1100;
					ALU_o=0;
					Jump_type_out = 1'b0;
				end
			endcase
		end
		3'b110: 	begin
			ALUCtrl_o=4'b0001;		//ori			
			Jump_type_out = 1'b0;
		end
		3'b111:	begin
			ALUCtrl_o=4'b0011;		//lui
			Jump_type_out = 1'b0;
		end
		3'b101:  begin 
			ALUCtrl_o=4'b1010;
			Jump_type_out = 1'b0;
		end
		3'b100:  begin
			ALUCtrl_o=4'b1001;		//jal			need check
			Jump_type_out = 1'b0;
		end
		default:  begin
			ALUCtrl_o=4'b1100;
			ALU_o=0;
			Jump_type_out = 1'b0;
		end
	endcase
end
endmodule                      