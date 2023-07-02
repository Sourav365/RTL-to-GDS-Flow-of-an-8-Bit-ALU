`timescale 1ns / 1ps

module alu(A,B,op_code,clk,en,result_out,flag_carry,flag_zero);
	parameter N=8;
	input [N-1:0] A,B;
	input [2:0] op_code;
	input clk,en;
	output [N-1:0] result_out;
	output reg flag_carry,flag_zero;
	
	reg [N-1:0] result;
	parameter ADD=3'b000,
		  ADC=3'b001,
		  SUB=3'b010,
		  INC=3'b011,
		  DEC=3'b100,
		  CMP=3'b101,
		  SHL=3'b110,
		  SHR=3'b111;

	assign result_out=result;

	always @(posedge clk) begin
	   if(en) begin
            case(op_code)
            ADD: {flag_carry,result} = A+B;
            ADC: {flag_carry,result} = A+B+flag_carry;
            SUB: {flag_carry,result} = A-B;
            INC: {flag_carry,result} = A+1'b1;
            DEC: {flag_carry,result} = A-1'b1;
            CMP: 
                begin 
                    if(A<B) result=1; 
                    else if (A==B) result=2;
                    else result=4;
                end
            SHL: result = A<<1;
            SHR: result = A>>1;
            default: result = 'hXX;
            endcase
        end
		flag_zero=(result==0)?1:0;

	end
endmodule