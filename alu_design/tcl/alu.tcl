set_attribute lib_search_path {../lib/new}
set_attribute hdl_search_path {../rtl/}
set_attribute library {fsa0m_a_generic_core_tt1p8v25c.lib}
set myFiles [list alu.v]
set basename alu;
set runname synthesys_report;

read_hdl ${myFiles}
elaborate ${basename}
read_sdc ../constraints/constraints_top.sdc

synthesize -to_mapped
report timing > ${basename}_${runname}_timing.rpt
report gates > ${basename}_${runname}_cell.rpt
report power > ${basename}_${runname}_power.rpt
report area  > ${basename}_${runname}_area.rpt

write_hdl -mapped > ${basename}_${runname}.v
write_sdc > ${basename}_${runname}.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge  -setuphold split > delays.sdf
gui_show
