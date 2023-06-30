# VLSI-Backend-Design-Flow-Based-on-Cadence-tools
VLSI Backend Design Flow / Physical Design Based on Cadence-tools

## Cadence tools to be used

1. NCLaunch -> For RTL Simulation
2. Genus	-> Synthesize RTL code
3. Innovus	-> Placement & Routing

## Required Folders and files

Main_Design_Folder

    |-> rtl --> verilog_code.v
            --> test_bench.v
           
    |-> tcl --> tcl_file.tcl
           
    |-> lib --> ...generic_core_tt.lib
            --> ...generic_core_ff.lib
            --> ...generic_core_ss.lib
            --> fsa0m_a_generic_core.v
            
    |-> constraints --> constraints_file.sdc
    
    |-> lef_files --> header6_V55.lef
                  --> fsa0m_a_generic_core.lef      + FSA0M_A_GENERIC_CORE_ANT_V55.6.lef
                  --> foa0a_o_t33_generic_cd_io.lef + FOA0A_O_T33_GENERIC_CD_IO_ANT_V55.lef
    
    |-> genus --> <<Initially no files>>
    
    
    |-> innovus --> alu_top_innovus.v (Netlist + Input output pads ) (Innovus Top Module Verilog file)
                --> pads_alu.io
                --> alu_synthesys_report.sdc (Constraint file generated after synthesys inside genus folder)
                --> 

## RTL file (.v)

```
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
```

## TCL file (.tcl)

```
set_attribute lib_search_path {../lib/}                     //Library file path 
set_attribute hdl_search_path {../rtl/}                     //RTL files path
set_attribute library {fsa0m_a_generic_core_tt1p8v25c.lib}  //Specify library
set myFiles [list alu.v]                                    //All Verilog files
set basename alu;                                           //Top module name
set runname synthesys_report;

read_hdl ${myFiles}
elaborate ${basename}
read_sdc ../constraints/constraints_file.sdc               //Constraint file (.sdc)

synthesize -to_mapped
report timing > ${basename}_${runname}_timing.rpt          //Output file
report gates > ${basename}_${runname}_cell.rpt             //Output file 
report power > ${basename}_${runname}_power.rpt            //Output file
report area  > ${basename}_${runname}_area.rpt             //Output file

write_hdl -mapped > ${basename}_${runname}.v               //Generated library mapped netlist
write_sdc > ${basename}_${runname}.sdc                     //Achieved Constraint file
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge  -setuphold split > delays.sdf  //????????????????
gui_show                                                    //To show result in GUI mode

```

## Constraint File (.sdc)

```
create_clock -name clk -period 10 -waveform {0 5} [get_ports "clk"]
set_clock_transition -rise 0.1 [get_clocks "clk"]
set_clock_transition -fall 0.1 [get_clocks "clk"]
set_clock_uncertainty 0.01 [get_ports "clk"]

set_input_delay -max 1.0 [get_ports "A"] -clock [get_clocks "clk"]
set_input_delay -max 1.0 [get_ports "B"] -clock [get_clocks "clk"]
set_input_delay -max 1.0 [get_ports "op_code"] -clock [get_clocks "clk"]
set_input_delay -max 1.0 [get_ports "en"] -clock [get_clocks "clk"]


set_output_delay -max 1.0 [get_ports "result_out"] -clock [get_clocks "clk"]
set_output_delay -max 1.0 [get_ports "flag_carry"] -clock [get_clocks "clk"]
set_output_delay -max 1.0 [get_ports "flag_zero"] -clock [get_clocks "clk"]
```

## Innovus Top Module Verilog file (.v)

```
/* 
 * It contains 2 parts
 * 1. Netlist module generated after Systhesys process (Using Genus)
 * 2. Pad integration IO module
 */

// 1. Netlist Module
/* module alu (.................................................);   */
/*********************************************************************/
/******************** INSERT NETLIST MODULE HERE *********************/
/*********************************************************************/
/* endmodule */


// 2. Pad Integration Module
module alu_top_module(result_out_out,flag_carry_out, flag_zero_out,A_in,B_in,op_code_in,clk_in, en_in);

	input [7:0] A_in, B_in;
	input [2:0] op_code_in;
	input clk_in, en_in;
	
	output [7:0] result_out_out;
	output flag_carry_out, flag_zero_out;
	
	wire [7:0] A_out, B_out;
	wire [2:0] op_code_out;
	wire clk_out, en_out;
	
	wire [7:0] result_out_temp;
	wire flag_carry_temp, flag_zero_temp;
	
	
	
	wire logic1,logic0;
	
	assign logic1=1'b1;
	assign logic0=1'b0;
	
	///////////.....................INPUT DIGITAL PADS....////
	XMC A0(.O(A_out[0]),.I(A_in[0]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A1(.O(A_out[1]),.I(A_in[1]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A2(.O(A_out[2]),.I(A_in[2]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A3(.O(A_out[3]),.I(A_in[3]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A4(.O(A_out[4]),.I(A_in[4]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A5(.O(A_out[5]),.I(A_in[5]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A6(.O(A_out[6]),.I(A_in[6]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A7(.O(A_out[7]),.I(A_in[7]),.PU(logic1),.PD(logic1),.SMT(logic1));
	
	XMC B0(.O(B_out[0]),.I(B_in[0]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B1(.O(B_out[1]),.I(B_in[1]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B2(.O(B_out[2]),.I(B_in[2]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B3(.O(B_out[3]),.I(B_in[3]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B4(.O(B_out[4]),.I(B_in[4]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B5(.O(B_out[5]),.I(B_in[5]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B6(.O(B_out[6]),.I(B_in[6]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B7(.O(B_out[7]),.I(B_in[7]),.PU(logic1),.PD(logic1),.SMT(logic1));
	
	XMC op_code0(.O(op_code_out[0]),.I(op_code_in[0]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC op_code1(.O(op_code_out[1]),.I(op_code_in[1]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC op_code2(.O(op_code_out[2]),.I(op_code_in[2]),.PU(logic1),.PD(logic1),.SMT(logic1));
	
	XMC clk(.O(clk_out),.I(clk_in),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC en(.O(en_out),.I(en_in),.PU(logic1),.PD(logic1),.SMT(logic1));
	
	//////////...................OUTPUT DIGITAL PADS....../////
	YA2GSC result0(.I(result_out_temp[0]),.O(result_out_out[0]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result1(.I(result_out_temp[1]),.O(result_out_out[1]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result2(.I(result_out_temp[2]),.O(result_out_out[2]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result3(.I(result_out_temp[3]),.O(result_out_out[3]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result4(.I(result_out_temp[4]),.O(result_out_out[4]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result5(.I(result_out_temp[5]),.O(result_out_out[5]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result6(.I(result_out_temp[6]),.O(result_out_out[6]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result7(.I(result_out_temp[7]),.O(result_out_out[7]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	
	
	YA2GSC flag_carry(.I(flag_carry_temp),.O(flag_carry_out),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC flag_zero(.I(flag_zero_temp),.O(flag_zero_out),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	
	
	///
	alu top1(A_out, B_out, op_code_out, clk_out, en_out, result_out_temp, flag_carry_temp, flag_zero_temp);

endmodule





```

## Pads IO file (.io)

```

```


## Before invoking Cadence tools
Run the following commands
```
cd /Design/MTECH/MTECH2021/EE_GRP11/Desktop/Cadence_22/
source .cdsbashrc
```

## To run a Cadence tool
(Go to design folder eg. ```cd Sourav/alu_design_2/genus/``` . Then invoke particular tool inside that tool-named-folder.)

1. Open NCLaunch GUI ```.............``` or directly ```nclaunch &```

2. Open Genus GUI ```/Application/Cadence/GENUS201/bin/genus -legacy_ui``` or directly ```genus -legacy_ui```

3. Open innovus GUI ```/Application/Cadence/INNOVUS201/bin/innovus``` or directly ```innovus```





## Steps---->
### 0. Start Cadence tools
```
cd /Design/MTECH/MTECH2021/EE_GRP11/Desktop/Cadence_22/
source .cdsbashrc
```
### 1. Verify RTL design
Use NCLaunch or NCSim or Xilinx Vivado tool to verify RTL code.

Required files 
1. verilog_code.v 
2. test_bench.v

### 2. Generate Netlist after synthesys
```
cd Sourav/alu_design_2/genus/
/Application/Cadence/GENUS201/bin/genus -legacy_ui
source ../tcl/alu.tcl
```

Click on (+) tab to see schematic of the mapped netlist

<img width="250" alt="image" src="https://user-images.githubusercontent.com/49667585/233337096-4447da17-22d9-4334-b84e-871d4fecc1db.png">

<img width="487" alt="image" src="https://user-images.githubusercontent.com/49667585/233338045-02285a07-43e2-4274-8597-5bdbafb4bf9a.png">

**Timing**, **Gates**, **Power**, **Area repports** will generate inside _../genus/_ folder.

Technology mapped "Netlist" and "Constraint" file will be generated.

### 3. Verify post Synthesys netlist
Use NCLaunch or NCSim or Xilinx Vivado tool to verify Post Synthesized Netlist code.

Required files 
1. netlist_synthesys_report.v 
2. fsa0m_a_generic_core.v
3. test_bench.v

### 4. Generating 


### 5. dfg
