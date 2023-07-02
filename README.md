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
    
    
    |-> innovus --> alu_top_innovus.v (Netlist(core) + IO pads) (Innovus Top Module Verilog file)
                --> pads_alu.io
                --> alu_synthesys_report_innovus.sdc (Constraint file generated after synthesys inside genus folder modify the outputs according to innovus top module pins)
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





# Steps---->
## 0. Start Cadence tool & Write RTL Code
```
cd /Design/MTECH/MTECH2021/EE_GRP11/Desktop/Cadence_22/
source .cdsbashrc
```
## 1. Verify RTL design
Use NCLaunch or NCSim or Xilinx Vivado tool to verify RTL code.

Required files 
1. verilog_code.v 
2. test_bench.v

## 2. Generate Netlist after synthesys

### Create Constraint File (.sdc)

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

### Create TCL file (.tcl)

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
### Run commands for Synthesize
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

## 3. Verify post Synthesys netlist
Use NCLaunch or NCSim or Xilinx Vivado tool to verify Post Synthesized Netlist code.

Required files 
1. netlist_synthesys_report.v 
2. fsa0m_a_generic_core.v
3. test_bench.v

## 4. Placement & Routing 

### Innovus Top Module Verilog file (.v)
<img width="600" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/d8ecebcc-1b8a-45d8-9c53-7b4d2cb581d4">

```
/* 
 * It contains 2 parts
 * 1. Core (Netlist module generated after Systhesys process (Using Genus))
 * 2. IO Pad module
 */

// 1. Netlist Module
/* module alu_netlist (.........................................);   */
/*********************************************************************/
/******************** INSERT NETLIST MODULE HERE *********************/
/*********************************************************************/
/* endmodule */


// 2. Top Module with IO Pad Module
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
	
	/*********************** INPUT DIGITAL PADS ************************/
	// input [7:0] A
	XMC A0(.O(A_out[0]),.I(A_in[0]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A1(.O(A_out[1]),.I(A_in[1]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A2(.O(A_out[2]),.I(A_in[2]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A3(.O(A_out[3]),.I(A_in[3]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A4(.O(A_out[4]),.I(A_in[4]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A5(.O(A_out[5]),.I(A_in[5]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A6(.O(A_out[6]),.I(A_in[6]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC A7(.O(A_out[7]),.I(A_in[7]),.PU(logic1),.PD(logic1),.SMT(logic1));

	// input [7:0] B
	XMC B0(.O(B_out[0]),.I(B_in[0]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B1(.O(B_out[1]),.I(B_in[1]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B2(.O(B_out[2]),.I(B_in[2]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B3(.O(B_out[3]),.I(B_in[3]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B4(.O(B_out[4]),.I(B_in[4]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B5(.O(B_out[5]),.I(B_in[5]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B6(.O(B_out[6]),.I(B_in[6]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC B7(.O(B_out[7]),.I(B_in[7]),.PU(logic1),.PD(logic1),.SMT(logic1));

	// input [2:0] op_code
	XMC op_code0(.O(op_code_out[0]),.I(op_code_in[0]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC op_code1(.O(op_code_out[1]),.I(op_code_in[1]),.PU(logic1),.PD(logic1),.SMT(logic1));
	XMC op_code2(.O(op_code_out[2]),.I(op_code_in[2]),.PU(logic1),.PD(logic1),.SMT(logic1));

	// input clk
	XMC clk(.O(clk_out),.I(clk_in),.PU(logic1),.PD(logic1),.SMT(logic1));
	// input en
	XMC en(.O(en_out),.I(en_in),.PU(logic1),.PD(logic1),.SMT(logic1));


	/*********************** OUTPUT DIGITAL PADS ************************/
	// output [7:0] result
	YA2GSC result0(.I(result_out_temp[0]),.O(result_out_out[0]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result1(.I(result_out_temp[1]),.O(result_out_out[1]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result2(.I(result_out_temp[2]),.O(result_out_out[2]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result3(.I(result_out_temp[3]),.O(result_out_out[3]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result4(.I(result_out_temp[4]),.O(result_out_out[4]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result5(.I(result_out_temp[5]),.O(result_out_out[5]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result6(.I(result_out_temp[6]),.O(result_out_out[6]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	YA2GSC result7(.I(result_out_temp[7]),.O(result_out_out[7]),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));

	// output flag_carry
	YA2GSC flag_carry(.I(flag_carry_temp),.O(flag_carry_out),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	// output flag_zero
	YA2GSC flag_zero(.I(flag_zero_temp),.O(flag_zero_out),.E(logic1),.E2(logic1),.E4(logic1),.SR(logic0));
	
	
	/*********************** Call the Netlist Module ************************/
	alu_netlist alu_core(.A(A_out), .B(B_out), .opcode(op_code_out), .clk(clk_out), .en(en_out), .result_out(result_out_temp), .flag_carry(flag_carry_temp), .flag_zero(flag_zero_temp));

endmodule

```

### Pads IO file (.io)

```
(globals 
   version=1
   io_order = clockwise
   space = 5
   total_edge=8
)

(iopad
    (topleft
      (inst name="CornerCell1" cell=CORNERC offset=0 orientation=R180 place_status=fixed
     )
     
     (left 
          (inst name="op_code0" cell=XMC place_status=fixed)
          (inst name="op_code1" cell=XMC place_status=fixed)
 	  (inst name="op_code2" cell=XMC place_status=fixed)
 	  (inst name="clk" cell=XMC place_status=fixed)
 	  (inst name="en" cell=XMC place_status=fixed)
          (inst name="VDD" cell=VCCKC place_status=fixed)
 	  (inst name="GND" cell=GNDKC place_status=fixed)
 	  (inst name="extra_pin1" cell=XMC place_status=fixed)
 	  (inst name ="VDDO" cell = VCC3IOC place_status = fixed)
 	  (inst name = "GNDO" cell = GNDIOC place_status = fixed)
      )

    (topright
      (inst name="CornerCell2" cell=CORNERC offset=0 orientation=R90 place_status=fixed)
     )
     
     (top 
	  (inst name="A0" cell=XMC place_status=fixed)
          (inst name="A1" cell=XMC place_status=fixed)
          (inst name="A2" cell=XMC place_status=fixed)
          (inst name="A3" cell=XMC place_status=fixed)
 	  (inst name="A4" cell=XMC place_status=fixed)
          (inst name="A5" cell=XMC place_status=fixed)
          (inst name="A6" cell=XMC place_status=fixed)
          (inst name="A7" cell=XMC place_status=fixed)   
      )

    (bottomright
      (inst name="CornerCell3" cell=CORNERC offset=0 orientation=R0 place_status=fixed)
     )
     
     (right 
          (inst name="result0" cell=YA2GSC place_status=fixed)
          (inst name="result1" cell=YA2GSC place_status=fixed)
          (inst name="result2" cell=YA2GSC place_status=fixed)
          (inst name="result3" cell=YA2GSC place_status=fixed)
	  (inst name="result4" cell=YA2GSC place_status=fixed)
          (inst name="result5" cell=YA2GSC place_status=fixed)
          (inst name="result6" cell=YA2GSC place_status=fixed)
          (inst name="result7" cell=YA2GSC place_status=fixed)
          (inst name="flag_carry" cell=YA2GSC place_status=fixed)
 	  (inst name="flag_zero" cell=YA2GSC place_status=fixed)
      )

    (bottomleft
      (inst name="CornerCell4" cell=CORNERC offset=0 orientation=R270 place_status=fixed)
     )
     
     (bottom 
 	  (inst name="B0" cell=XMC place_status=fixed)
 	  (inst name="B1" cell=XMC place_status=fixed)
          (inst name="B2" cell=XMC place_status=fixed)
          (inst name="B3" cell=XMC place_status=fixed)
 	  (inst name="B4" cell=XMC place_status=fixed)
          (inst name="B5" cell=XMC place_status=fixed)
          (inst name="B6" cell=XMC place_status=fixed)
          (inst name="B7" cell=XMC place_status=fixed)    
      )

```

### Create Constraint (.sdc) File for Layout
Copy the output constraint file (.sdc) generated after synthesys. **Change the input output ports to the Top module port names**.

```
# ####################################################################

#  Created by Genus(TM) Synthesis Solution 20.10-p001_1 on Thu Apr 20 16:19:15 IST 2023

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design alu

create_clock -name "clk" -period 10.0 -waveform {0.0 5.0} [get_ports clk_in] #########how to give clk port name????????????????##################################
set_clock_transition 0.1 [get_clocks clk_in]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {A_in[7]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {A_in[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {A_in[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {A_in[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {A_in[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {A_in[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {A_in[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {A_in[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {B_in[7]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {B_in[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {B_in[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {B_in[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {B_in[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {B_in[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {B_in[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {B_in[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {op_code_in[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {op_code_in[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {op_code_in[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports en_in]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {result_out_out[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {result_out_out[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {result_out_out[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {result_out_out[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {result_out_out[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {result_out_out[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {result_out_out[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {result_out_out[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports flag_carry_out]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports flag_zero_out]
set_wire_load_mode "enclosed"
set_clock_uncertainty -setup 0.01 [get_ports clk_in]
set_clock_uncertainty -hold 0.01 [get_ports clk_in]

```

We can also do without the IO pads as of now. Considering only the Core area. So for this, required files are - [Link](https://www.youtube.com/watch?v=odMKqvrAz3s)

1. netlist.v (Generated after synthesys)
2. constraint.sdc (Generated after synthesys)

### Run the Innovus tool

```
cd Sourav/alu_design_2/innovus
/Application/Cadence/INNOVUS201/bin/innovus
```

On the GUI screen do the followings

1. File -> import Design
   
   Netlist -> Verilog files -> innovus_top_module.v
   
   Technology lib -> LEF Files ->
   
		i) FOA0A_O_T33_GENERIC_CD_IO_ANT_V55.lef, FSA0M_A_GENERIC_CORE_ANT_V55.6.lef, foa0a_o_t33_generic_cd_io.lef, fsa0m_a_generic_core.lef, header6_V55.lef (If using Pads with core)
  		ii) header6_V55.lef, FSA0M_A_GENERIC_CORE_ANT_V55.6.lef, fsa0m_a_generic_core.lef (If using only core)
   
	Power nets -> VDD VDDO

	Ground Nets -> GND GNDO

	Save the config.

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/eb62a8bc-b9ac-4c06-a7ea-b154dbb2fa27">

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/1bc5d4a5-d286-49c8-8c0b-27a4b5d58dcf">

2. Floorplan -> Specify floor plan -> 

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/4fd07cb2-4c60-4ada-8b48-b281cefb8bb8">

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/c91cdfc0-d0d7-4954-ba60-e57d2890691b">

3. Place -> Physical cell -> Add IO Filler -> EMPTY1C -> Top, Buttom, Left, Right
   
<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/9a628eef-3d0e-4c8f-bfb6-db693459f934">

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/915a70af-bfe7-4be4-a1e4-5ce89211e9fe">

4. Power -> Power planning -> Add Ring -> Do all the followings

   i) Top, Buttom => Metal1   Left, Right => Metal2
   ii) Top, Buttom => Metal3   Left, Right => Metal4
   iii) Top, Buttom => Metal5   Left, Right => Metal4
   
<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/423ed5fa-1227-468f-854b-05c350facc15">

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/4feefb94-73d3-4f85-8bad-25116c1b774e">

5. Power -> Power planning -> Add Stripe -> Add VDD GND Vertical Power strips

   Select the extream sides nets and delete.

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/f0659ac9-128d-4190-86ef-bf12fb7b8d56">
<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/31f6cc70-5c7a-44a1-909c-cb696fd6b9b7">

6. Connect Global Nets
   (To connect internal Power Global Nets to the Output pins)
   
	```
	clearGlobalNets
	globalNetConnect VDD -type pgpin -pin VCC -instanceBasename {} -override -verbose
	globalNetConnect GND -type pgpin -pin GND -instanceBasename {} -override -verbose
	
	globalNetConnect VDDO -type tiehi
	globalNetConnect GNDO -type tielo
	```
 
  Using GUI

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/a12eb2d5-53d0-4a21-975e-124c154328d8">

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/2fd4bd0c-5732-493c-a63f-c700565d9070">

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/43c4a129-299a-48c3-849d-b727986beea9">

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/e347964e-c609-43ac-ac66-167a79f23e4d">


7. Place->std cells
   (Placing standard cells to the design)

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/d9204528-2b42-42f3-8aba-b621b1b33250">


8. To provide Horizontal strips
   Route -> Special Route
   (Shows the Global net connections)

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/4674f704-7e32-47f0-95f9-b247cff6976b">

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/51d5fcad-5080-478b-848e-89d639debade">

9. Route -> Nano route -> Route
   (To reduce the DRC Violations)

<img width="500" alt="image" src="https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/32deace3-64a9-4cc3-b064-0b8a573b620e">


## 5. Results

### 1. DRC Check 
  Verify -> Verify DRC
![image](https://github.com/Sourav365/VLSI-Backend-Design-Flow-Based-on-Cadence-tools/assets/49667585/a512260e-5a97-4d08-a63d-eaf06c457d31)

### 2. STA Analysis
   1. Timing -> MMMC Browser
   
   Library Sets-> Max_timing=> ss library, Min_timing=> ff library

   Delay Corners-> Max_delay=> Max_timing, Min_delay=> Min_timing

   Constraint modes -> Add Top level constraint file at innovus (Constraint file for Layout)

   Analysis View -> Worst_case => Max_delay, Best_case => Min_delay

   Setup Analysis view -> Worst_case

   Hold Analysis view -> Best_case

2. Timing -> Report timing -> Pre-CTS -> Setup -> ok
