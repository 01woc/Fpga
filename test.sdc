## Generated SDC file "test.sdc"

## Copyright (C) 2024  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 23.1std.1 Build 993 05/14/2024 SC Lite Edition"

## DATE    "Sun Mar  9 20:41:26 2025"

##
## DEVICE  "5CSXFC6D6F31C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {hihi_clock} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {hihi_clock}] -rise_to [get_clocks {hihi_clock}] -setup 0.170  
set_clock_uncertainty -rise_from [get_clocks {hihi_clock}] -rise_to [get_clocks {hihi_clock}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {hihi_clock}] -fall_to [get_clocks {hihi_clock}] -setup 0.170  
set_clock_uncertainty -rise_from [get_clocks {hihi_clock}] -fall_to [get_clocks {hihi_clock}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {hihi_clock}] -rise_to [get_clocks {hihi_clock}] -setup 0.170  
set_clock_uncertainty -fall_from [get_clocks {hihi_clock}] -rise_to [get_clocks {hihi_clock}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {hihi_clock}] -fall_to [get_clocks {hihi_clock}] -setup 0.170  
set_clock_uncertainty -fall_from [get_clocks {hihi_clock}] -fall_to [get_clocks {hihi_clock}] -hold 0.060  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {button_freq_dec}]
set_input_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {button_freq_inc}]
set_input_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {noise_enable}]
set_input_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {reset}]
set_input_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {rst_n}]
set_input_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {switches[0]}]
set_input_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {switches[1]}]
set_input_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {switches[2]}]
set_input_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {switches[3]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[0]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[1]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[2]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[3]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[4]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[5]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[6]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[7]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[8]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[9]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[10]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[11]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[12]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[13]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[14]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[15]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[16]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[17]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[18]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[19]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[20]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[21]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[22]}]
set_output_delay -add_delay  -clock [get_clocks {hihi_clock}]  1.000 [get_ports {waveform_out[23]}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

