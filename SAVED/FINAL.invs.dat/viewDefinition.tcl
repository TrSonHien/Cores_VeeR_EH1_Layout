if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name sky130_tc\
   -timing\
    [list ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_1024x16_c2_bm_bist_typ_1p20V_25C.lib\
    ${::IMEX::libVar}/mmmc/sg13g2_io_typ_1p2V_3p3V_25C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_256x64_c2_bm_bist_typ_1p20V_25C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_2048x64_c2_bm_bist_typ_1p20V_25C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_1024x64_c2_bm_bist_typ_1p20V_25C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_4096x16_c3_bm_bist_typ_1p20V_25C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_1024x8_c2_bm_bist_typ_1p20V_25C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_512x64_c2_bm_bist_typ_1p20V_25C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_4096x8_c3_bm_bist_typ_1p20V_25C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_64x64_c2_bm_bist_typ_1p20V_25C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_256x48_c2_bm_bist_typ_1p20V_25C.lib\
    ${::IMEX::libVar}/mmmc/sg13g2_stdcell_typ_1p20V_25C.lib\
    ${::IMEX::libVar}/mmmc/sg13g2_io_typ_1p5V_3p3V_25C.lib]
create_library_set -name sky130_bc\
   -timing\
    [list ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_1024x8_c2_bm_bist_fast_1p32V_m55C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_4096x8_c3_bm_bist_fast_1p32V_m55C.lib\
    ${::IMEX::libVar}/mmmc/sg13g2_io_fast_1p65V_3p6V_m40C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_256x64_c2_bm_bist_fast_1p32V_m55C.lib\
    ${::IMEX::libVar}/mmmc/sg13g2_io_fast_1p32V_3p6V_m40C.lib\
    ${::IMEX::libVar}/mmmc/sg13g2_stdcell_fast_1p32V_m40C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_64x64_c2_bm_bist_fast_1p32V_m55C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_1024x64_c2_bm_bist_fast_1p32V_m55C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_1024x16_c2_bm_bist_fast_1p32V_m55C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_4096x16_c3_bm_bist_fast_1p32V_m55C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_256x48_c2_bm_bist_fast_1p32V_m55C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_2048x64_c2_bm_bist_fast_1p32V_m55C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_512x64_c2_bm_bist_fast_1p32V_m55C.lib]
create_library_set -name sky130_wc\
   -timing\
    [list ${::IMEX::libVar}/mmmc/sg13g2_stdcell_slow_1p08V_125C.lib\
    ${::IMEX::libVar}/mmmc/sg13g2_io_slow_1p08V_3p0V_125C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_1024x8_c2_bm_bist_slow_1p08V_125C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_1024x64_c2_bm_bist_slow_1p08V_125C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_256x48_c2_bm_bist_slow_1p08V_125C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_2048x64_c2_bm_bist_slow_1p08V_125C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_1024x16_c2_bm_bist_slow_1p08V_125C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_4096x16_c3_bm_bist_slow_1p08V_125C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_512x64_c2_bm_bist_slow_1p08V_125C.lib\
    ${::IMEX::libVar}/mmmc/sg13g2_io_slow_1p35V_3p0V_125C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_64x64_c2_bm_bist_slow_1p08V_125C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_256x64_c2_bm_bist_slow_1p08V_125C.lib\
    ${::IMEX::libVar}/mmmc/RM_IHPSG13_1P_4096x8_c3_bm_bist_slow_1p08V_125C.lib]
create_op_cond -name WCCOM -library_file ${::IMEX::libVar}/mmmc/sg13g2_stdcell_slow_1p08V_125C.lib -P 1 -V 1.08 -T 100
create_op_cond -name TCCOM -library_file ${::IMEX::libVar}/mmmc/sg13g2_stdcell_typ_1p20V_25C.lib -P 1 -V 1.2 -T 25
create_op_cond -name BCCOM -library_file ${::IMEX::libVar}/mmmc/sg13g2_stdcell_fast_1p32V_m40C.lib -P 1 -V 1.32 -T -40
create_rc_corner -name default_rc_corner\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name delay_tc\
   -library_set sky130_tc\
   -opcond TCCOM
create_delay_corner -name delay_bc\
   -library_set sky130_bc\
   -opcond BCCOM
create_delay_corner -name delay_wc\
   -library_set sky130_wc\
   -opcond WCCOM
create_constraint_mode -name func_mode_ideal_bc\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/func_mode_ideal_bc/func_mode_ideal_bc.sdc]
create_constraint_mode -name func_mode_prop\
   -sdc_files\
    [list ${::IMEX::libVar}/mmmc/constraints.sdc]
create_constraint_mode -name func_mode_ideal_wc\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/func_mode_ideal_wc/func_mode_ideal_wc.sdc]
create_analysis_view -name func_view_tc -constraint_mode func_mode_ideal_wc -delay_corner delay_tc
create_analysis_view -name func_view_bc -constraint_mode func_mode_ideal_bc -delay_corner delay_bc -latency_file ${::IMEX::dataVar}/mmmc/views/func_view_bc/latency.sdc
create_analysis_view -name func_view_wc -constraint_mode func_mode_ideal_wc -delay_corner delay_wc -latency_file ${::IMEX::dataVar}/mmmc/views/func_view_wc/latency.sdc
set_analysis_view -setup [list func_view_wc] -hold [list func_view_bc]
catch {set_interactive_constraint_mode [list func_mode_ideal_bc func_mode_ideal_wc] } 
