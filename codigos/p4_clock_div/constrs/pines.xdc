# Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK]							
	set_property IOSTANDARD LVCMOS33 [get_ports CLK]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]
 
# Switches
set_property PACKAGE_PIN V17 [get_ports {SEL[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEL[0]}]
set_property PACKAGE_PIN V16 [get_ports {SEL[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEL[1]}]
#set_property PACKAGE_PIN W16 [get_ports {sw[2]}]

##Pmod Header JB
##Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {LED}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED}]
