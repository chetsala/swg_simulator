##RGB LED 5 (Zybo Z7-20 only)
set_property -dict { PACKAGE_PIN Y11   IOSTANDARD LVCMOS33 } [get_ports { LD5[2] }]; #IO_L18N_T2_13 Sch=led5_r
set_property -dict { PACKAGE_PIN T5    IOSTANDARD LVCMOS33 } [get_ports { LD5[1] }]; #IO_L19P_T3_13 Sch=led5_g
set_property -dict { PACKAGE_PIN Y12   IOSTANDARD LVCMOS33 } [get_ports { LD5[0] }]; #IO_L20P_T3_13 Sch=led5_b

##RGB LED 6
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { LD6[2] }]; #IO_L18P_T2_34 Sch=led6_r
set_property -dict { PACKAGE_PIN F17   IOSTANDARD LVCMOS33 } [get_ports { LD6[1] }]; #IO_L6N_T0_VREF_35 Sch=led6_g
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { LD6[0] }]; #IO_L8P_T1_AD10P_35 Sch=led6_b
