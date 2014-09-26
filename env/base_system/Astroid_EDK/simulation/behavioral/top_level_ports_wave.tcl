#  Simulation Model Generator
#  Xilinx EDK 14.2 EDK_P.28xd
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     top_level_ports_wave.tcl (Fri Sep 26 12:22:37 2014)
#
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system" }

wave add $tbpath${ps}RS232_Uart_1_sout -into $id 
wave add $tbpath${ps}RS232_Uart_1_sin -into $id 
wave add $tbpath${ps}RESET -into $id 
wave add $tbpath${ps}Push_Buttons_4Bits_TRI_I -into $id 
wave add $tbpath${ps}LEDs_8Bits_TRI_O -into $id 
wave add $tbpath${ps}GCLK -into $id 
wave add $tbpath${ps}DIP_Switches_8Bits_TRI_I -into $id 
wave add $tbpath${ps}VGA_HSYNC -into $id 
wave add $tbpath${ps}VGA_VSYNC -into $id 
wave add $tbpath${ps}VGA_RED -into $id 
wave add $tbpath${ps}VGA_GREEN -into $id 
wave add $tbpath${ps}VGA_BLUE -into $id 
