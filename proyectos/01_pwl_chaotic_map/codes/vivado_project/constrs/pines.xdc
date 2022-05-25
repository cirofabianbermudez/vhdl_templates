# Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK]							
	set_property IOSTANDARD LVCMOS33 [get_ports CLK]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]
 
	
set_property PACKAGE_PIN V17 [get_ports {START}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {START}]
				
set_property PACKAGE_PIN R2 [get_ports {RST}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {RST}]
	
	
##Pmod Header JB
##Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {DAC_SYNC}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {DAC_SYNC}]
#Sch name = JB2
set_property PACKAGE_PIN A16 [get_ports {DAC_SCLK}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {DAC_SCLK}]
##Sch name = JB3
set_property PACKAGE_PIN B15 [get_ports {DAC_DIN}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {DAC_DIN}]
##Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports {DAC_LDAC}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {DAC_LDAC}]
##Sch name = JB7
set_property PACKAGE_PIN A15 [get_ports {DAC_RST}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {DAC_RST}]