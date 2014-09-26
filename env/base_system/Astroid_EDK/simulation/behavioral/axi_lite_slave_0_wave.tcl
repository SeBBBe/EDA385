#  Simulation Model Generator
#  Xilinx EDK 14.2 EDK_P.28xd
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     axi_lite_slave_0_wave.tcl (Fri Sep 26 12:22:37 2014)
#
#  Module   system_axi_lite_slave_0_wrapper
#  Instance axi_lite_slave_0
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system" }

# wave add $tbpath${ps}axi_lite_slave_0${ps}ACLK -into $id
# wave add $tbpath${ps}axi_lite_slave_0${ps}ARESETN -into $id
# wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_AWADDR -into $id
# wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_AWPROT -into $id
# wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_AWVALID -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_AWREADY -into $id
# wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_WDATA -into $id
# wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_WSTRB -into $id
# wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_WVALID -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_WREADY -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_BRESP -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_BVALID -into $id
# wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_BREADY -into $id
# wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_ARADDR -into $id
# wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_ARPROT -into $id
# wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_ARVALID -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_ARREADY -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_RDATA -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_RRESP -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_RVALID -into $id
# wave add $tbpath${ps}axi_lite_slave_0${ps}S_AXI_RREADY -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}VGA_HSYNC -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}VGA_VSYNC -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}VGA_RED -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}VGA_GREEN -into $id
  wave add $tbpath${ps}axi_lite_slave_0${ps}VGA_BLUE -into $id

