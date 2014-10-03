#include "platform.h"
#include "tmrctr_v2_04_a/src/xtmrctr.h"

#include "xuartlite_l.h"
#include "xparameters.h"
#include "vga.h"

void print(char *str);

extern int volatile *vga;

vgapoint_t aship[4] =
{
  { 320, 230 },
  { 310, 250 },
  { 320, 245 },
  { 330, 250 },
};

int main()
{
    init_platform();

    XTmrCtr timer;
    XTmrCtr_Initialize(&timer, 0);

    //read input data
    xil_printf("start\n\r");

    while(!*vga);

    while(*vga);

    while(!*vga);

    XTmrCtr_Start(&timer, 0);

    while(*vga);

    while(!*vga);

    XTmrCtr_Stop(&timer, 0);
    int c = XTmrCtr_GetValue(&timer, 0);
    xil_printf("bin clock cycles = %d\n\r", c);

    xil_printf("main loop\n\r");

    game_main(0, 0);

    cleanup_platform();

    return 0;
}
