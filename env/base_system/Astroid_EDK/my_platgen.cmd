platgen -p xc6slx16csg324-3 -lang vhdl -intstyle default -lp C:/Xilinx/BSP/Nexys3_AXI_BSB_Support/lib/   -msg __xps/ise/xmsgprops.lst system.mhs

cd synthesis
del system_axi_lite_slave_0_wrapper_xst.scr
cd ..
copy system_axi_lite_slave_0_wrapper_xst.scr synthesis

cd synthesis

if exist xst rmdir /s /q xst

echo "xst -ifn "system_axi_lite_slave_0_wrapper_xst.scr" -intstyle silent"

echo "Running XST synthesis ..."

xst -ifn "system_axi_lite_slave_0_wrapper_xst.scr" -intstyle silent
if errorlevel 1 exit 1

echo "XST completed"

if exist xst rmdir /s /q xst
exit 0
