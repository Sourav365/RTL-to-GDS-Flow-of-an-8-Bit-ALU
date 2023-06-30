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
    
    
    |-> innovus --> pads_alu.io
                --> netlist_synthesys_report.v (Netlist file generated after synthesys inside genus)
                --> alu_synthesys_report.sdc (Constraint file generated after synthesys inside genus)
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
