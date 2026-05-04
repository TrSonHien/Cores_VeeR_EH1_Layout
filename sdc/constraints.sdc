###############################################################################
# SDC Constraints for VeeR EH1 Core (IHP 130nm)
# Based on Solderpad Hardware License Template
###############################################################################

############
## Global ##
############
set_units -time ns -capacitance pF -voltage V -current mA

# Accommodate for driving typical PCB trace and pad loads
set_load 0.01 [all_outputs]
#set_driving_cell -lib_cell sg13g2_IOPadOut16mA -pin pad [all_inputs]
set_driving_cell -lib_cell sg13g2_buf_16 -pin X [all_inputs]

##################
## Input Clocks ##
##################
puts "Defining Clocks..."

# Core Clock: 
set TCK_SYS 10.0
create_clock -name clk_sys -period $TCK_SYS [get_ports clk]

# JTAG Clock: 
set TCK_JTG 20.0
create_clock -name clk_jtg -period $TCK_JTG [get_ports jtag_tck]

##################################
## Clock Groups & Uncertainties ##
##################################

set_clock_groups -asynchronous -name async_domains \
     -group {clk_sys} \
     -group {clk_jtg}

set_clock_uncertainty 0.1 -setup [all_clocks]
set_clock_uncertainty 0.1 -hold  [all_clocks]
set_clock_transition  0.20 [all_clocks]

#############
## Resets  ##
#############
puts "Constraining Resets..."

set_input_delay -max [expr $TCK_SYS * 0.1] -clock clk_sys [get_ports rst_l]
set_false_path -hold -from [get_ports rst_l]

##########
## JTAG ##
##########
puts "Constraining JTAG..."

set_input_delay  -max [expr $TCK_JTG * 0.3] -clock clk_jtg [get_ports {jtag_tdi jtag_tms jtag_trst_n}]
set_input_delay  -min [expr $TCK_JTG * 0.1] -clock clk_jtg [get_ports {jtag_tdi jtag_tms jtag_trst_n}]
set_output_delay -max [expr $TCK_JTG * 0.3] -clock clk_jtg [get_ports jtag_tdo]
set_output_delay -min [expr $TCK_JTG * 0.1] -clock clk_jtg [get_ports jtag_tdo]

###########################
## System I/O (Bus/Int)  ##
###########################
puts "Constraining System I/O..."

set_input_delay  -max [expr $TCK_SYS * 0.3] -clock clk_sys [remove_from_collection [all_inputs] {clk jtag_tck rst_l}]
set_input_delay  -min [expr $TCK_SYS * 0.1] -clock clk_sys [remove_from_collection [all_inputs] {clk jtag_tck rst_l}]

set_output_delay -max [expr $TCK_SYS * 0.3] -clock clk_sys [remove_from_collection [all_outputs] {jtag_tdo}]
set_output_delay -min [expr $TCK_SYS * 0.1] -clock clk_sys [remove_from_collection [all_outputs] {jtag_tdo}]

puts "SDC Loading Completed."
