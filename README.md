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
           
    |-> lib --> generic_core_tt.lib
            --> generic_core_ff.lib
            --> generic_core_ss.lib
            
    |-> constraints --> constraints_file.sdc
    
    |-> lef_files --> header6_V55.lef
                  --> fsa0m_a_generic_core.lef      + FSA0M_A_GENERIC_CORE_ANT_V55.6.lef
                  --> foa0a_o_t33_generic_cd_io.lef + FOA0A_O_T33_GENERIC_CD_IO_ANT_V55.lef
    
    |-> genus --> Initially no files
    
    
    |-> innovus --> 

## TCL file

```
set_attribute lib_search_path {../lib/}                     #Library file path 
set_attribute hdl_search_path {../rtl/}                     #RTL files path
set_attribute library {fsa0m_a_generic_core_tt1p8v25c.lib}  #Specify library
set myFiles [list alu.v]                                    #All Verilog files
set basename alu;                                           # Top module name
set runname synthesys_report;

read_hdl ${myFiles}
elaborate ${basename}
read_sdc ../constraints/constraints_file.sdc               #Constraint file (.sdc)

synthesize -to_mapped
report timing > ${basename}_${runname}_timing.rpt          #Output file
report gates > ${basename}_${runname}_cell.rpt             #Output file
report power > ${basename}_${runname}_power.rpt            #Output file
report area  > ${basename}_${runname}_area.rpt             #Output file

write_hdl -mapped > ${basename}_${runname}.v               #Generated library mapped netlist
write_sdc > ${basename}_${runname}.sdc                     #?????????????
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge  -setuphold split > delays.sdf  //????????????????
gui_show                                                    #To show result in GUI mode

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

### 3. fdg


### 4. dfg


### 5. dfg
