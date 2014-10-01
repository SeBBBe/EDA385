#include "platform.h"
#include "tmrctr_v2_04_a/src/xtmrctr.h"

#include "xuartlite_l.h"
#include "xparameters.h"

void print(char *str);

int main()
{
    init_platform();

    XTmrCtr timer;
    XTmrCtr_Initialize(&timer, 0);

    //read input data
    xil_printf("start\n\r");

    while(!*((int *)0x7F800000));

    while(*((int *)0x7F800000));

    while(!*((int *)0x7F800000));

    XTmrCtr_Start(&timer, 0);

    while(*((int *)0x7F800000));

    while(!*((int *)0x7F800000));

    XTmrCtr_Stop(&timer, 0);
    int c = XTmrCtr_GetValue(&timer, 0);
    xil_printf("bin clock cycles = %d\n\r", c);

    xil_printf("main loop\n\r");

    game_main(0, 0);

    cleanup_platform();

    return 0;
}
