## This file is a general .xdc for the Zybo Z7 Rev. B
## It is compatible with the Zybo Z7-20 and Zybo Z7-10
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## This config file has been reduce down to a bare minimum to set up the seven segment PMOD to work on the two center connectors
## Connect the PMOD to the upper row of the connectors JD and JC (The ones directly "below" the main processing chip)

##Clock signal
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=sysclk
#create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }];


##Switches
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { value[0] }]; #IO_L19N_T3_VREF_35 Sch=sw[0]
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { value[1] }]; #IO_L24P_T3_34 Sch=sw[1]
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { value[2] }]; #IO_L4N_T0_34 Sch=sw[2]
set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { value[3] }]; #IO_L9P_T1_DQS_34 Sch=sw[3]


##Buttons
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { reset }]; #IO_L12N_T1_MRCC_35 Sch=btn[0]
#set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; #IO_L24N_T3_34 Sch=btn[1]
#set_property -dict { PACKAGE_PIN K19   IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]; #IO_L10P_T1_AD11P_35 Sch=btn[2]
#set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]; #IO_L7P_T1_34 Sch=btn[3]
                                                                                                                           
                                                                                                                                 
##Pmod Header JD                                                                                                                  
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33     } [get_ports { ssd_display[0] }]; #IO_L5P_T0_34 Sch=jd_p[1]                  
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33     } [get_ports { ssd_display[1] }]; #IO_L5N_T0_34 Sch=jd_n[1]				 
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33     } [get_ports { ssd_display[2] }]; #IO_L6P_T0_34 Sch=jd_p[2]                  
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33     } [get_ports { ssd_display[3] }]; #IO_L6N_T0_VREF_34 Sch=jd_n[2]             
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33     } [get_ports { SevenSD[0] }]; #IO_L11P_T1_SRCC_34 Sch=jd_p[3]            
#set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33     } [get_ports { SevenSD[1] }]; #IO_L11N_T1_SRCC_34 Sch=jd_n[3]            
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33     } [get_ports { SevenSD[2] }]; #IO_L21P_T3_DQS_34 Sch=jd_p[4]             
#set_property -dict { PACKAGE_PIN V18   IOSTANDARD LVCMOS33     } [get_ports { SevenSD[3] }]; #IO_L21N_T3_DQS_34 Sch=jd_n[4]             
                                                                                                                                 
                                                                                                                                 
##Pmod Header JE                                                                                                                  
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { ssd_display[4] }]; #IO_L4P_T0_34 Sch=je[1]						 
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { ssd_display[5] }]; #IO_L18N_T2_34 Sch=je[2]                     
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { ssd_display[6] }]; #IO_25_35 Sch=je[3]                          
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { c }]; #IO_L19P_T3_35 Sch=je[4]                     
#set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports { SevenSD[4] }]; #IO_L3N_T0_DQS_34 Sch=je[7]                  
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { SevenSD[5] }]; #IO_L9N_T1_DQS_34 Sch=je[8]                  
#set_property -dict { PACKAGE_PIN T17   IOSTANDARD LVCMOS33 } [get_ports { SevenSD[6] }]; #IO_L20P_T3_34 Sch=je[9]                     
#set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { c }]; #IO_L7N_T1_34 Sch=je[10]                    
