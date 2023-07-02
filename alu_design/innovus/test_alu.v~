`timescale 1ns / 1ps

module test_alu();
	parameter N=8;
	reg [N-1:0] A,B;
	reg [2:0] op_code;
	reg clk,en;
	wire [N-1:0] result_out;
	wire flag_carry,flag_zero;
	
	alu uut(A,B,op_code,clk,en,result_out,flag_carry,flag_zero);
	
	always #5 clk=~clk;
	
	initial begin
	   clk=0; en=0;
	   
	   #3; en=1;
	   op_code=3'b000;
       A=250; B=6;
       
       #10;
       op_code=3'b001;
       A=2; B=3;
       
       #10;
       op_code=3'b010;
       A=23; B=20;
       
       #10;
       op_code=3'b011;
       A=25;
       
       #10;
       op_code=3'b101;
       A=15; B=3;
       
       #10; $finish;
        
	end
endmodule
