#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sat Jul  1 14:48:13 2023                
#                                                     
#######################################################

#@(#)CDS: Innovus v20.10-p004_1 (64bit) 05/07/2020 20:02 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 20.10-p004_1 NR200413-0234/20_10-UB (database version 18.20.505) {superthreading v1.69}
#@(#)CDS: AAE 20.10-p005 (64bit) 05/07/2020 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 20.10-p005_1 () Apr 14 2020 09:14:28 ( )
#@(#)CDS: SYNTECH 20.10-b004_1 () Mar 12 2020 22:18:21 ( )
#@(#)CDS: CPE v20.10-p006
#@(#)CDS: IQuantus/TQuantus 19.1.3-s155 (64bit) Sun Nov 3 18:26:52 PST 2019 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
win
save_global top_module_globals
set init_gnd_net GND
set init_lef_file {../lef_files/FOA0A_O_T33_GENERIC_CD_IO_ANT_V55.lef ../lef_files/FSA0M_A_GENERIC_CORE_ANT_V55.6.lef ../lef_files/foa0a_o_t33_generic_cd_io.lef ../lef_files/fsa0m_a_generic_core.lef ../lef_files/header6_V55.lef}
set init_verilog alu_synthesys_report.v
set init_top_cell alu
set init_pwr_net VCC
init_design
set init_gnd_net GND
set init_lef_file {../lef_files/FOA0A_O_T33_GENERIC_CD_IO_ANT_V55.lef ../lef_files/FSA0M_A_GENERIC_CORE_ANT_V55.6.lef ../lef_files/foa0a_o_t33_generic_cd_io.lef ../lef_files/fsa0m_a_generic_core.lef ../lef_files/header6_V55.lef}
set init_verilog alu_synthesys_report.v
set init_top_cell alu
set init_pwr_net VCC
init_design
set init_gnd_net GND
set init_lef_file {../lef_files/FOA0A_O_T33_GENERIC_CD_IO_ANT_V55.lef ../lef_files/FSA0M_A_GENERIC_CORE_ANT_V55.6.lef ../lef_files/foa0a_o_t33_generic_cd_io.lef ../lef_files/fsa0m_a_generic_core.lef ../lef_files/header6_V55.lef}
set init_verilog alu_synthesys_report.v
set init_top_cell alu
set init_pwr_net VCC
init_design
set init_gnd_net GND
set init_lef_file {../lef_files/FOA0A_O_T33_GENERIC_CD_IO_ANT_V55.lef ../lef_files/FSA0M_A_GENERIC_CORE_ANT_V55.6.lef ../lef_files/foa0a_o_t33_generic_cd_io.lef ../lef_files/fsa0m_a_generic_core.lef ../lef_files/header6_V55.lef}
set init_verilog alu_synthesys_report.v
set init_top_cell alu
set init_pwr_net VCC
init_design
set init_gnd_net GND
set init_lef_file {../lef_files/FOA0A_O_T33_GENERIC_CD_IO_ANT_V55.lef ../lef_files/FSA0M_A_GENERIC_CORE_ANT_V55.6.lef ../lef_files/foa0a_o_t33_generic_cd_io.lef ../lef_files/fsa0m_a_generic_core.lef ../lef_files/header6_V55.lef}
set init_verilog alu_synthesys_report.v
set init_top_cell alu
set init_pwr_net VCC
init_design
save_global Default.globals
set init_gnd_net GND
set init_lef_file {../lef_files/header6_V55.lef ../lef_files/FSA0M_A_GENERIC_CORE_ANT_V55.6.lef ../lef_files/fsa0m_a_generic_core.lef}
set init_verilog alu_synthesys_report.v
set init_top_cell alu
set init_pwr_net VCC
init_design
set init_lef_file {../lef_files/FSA0M_A_GENERIC_CORE_ANT_V55.6.lef ../lef_files/fsa0m_a_generic_core.lef}
init_design
init_design
gui_select -rect {-1.16800 -0.28600 2.92300 2.54700}
gui_select -rect {-1.16800 0.02900 12.46900 13.35200}
deselectAll
fit
fit
zoomIn
zoomOut
zoomOut
zoomOut
fit
getIoFlowFlag
setIoFlowFlag 0
floorPlan -site core_5040 -r 0.888768312534 0.699987 30 30 30 30
uiSetTool select
getIoFlowFlag
fit
getIoFlowFlag
setIoFlowFlag 0
floorPlan -site core_5040 -r 0.888045540797 0.699418 25 25 25 25
uiSetTool select
getIoFlowFlag
fit
uiSetTool ruler
