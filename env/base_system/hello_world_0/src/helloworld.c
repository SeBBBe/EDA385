

#include <stdio.h>
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

    while(1)
    {
		while(!*((int *)0x7F800000));

		*((int *)0x7F800000) = 0x00000000;
		*((int *)0x7F800000) = 0x00FF00FF;

		*((int *)0x7F800000) = 0x000000FF;
		*((int *)0x7F800000) = 0x00FF0000;

		while(*((int *)0x7F800000));
    }

    cleanup_platform();

    return 0;
}
