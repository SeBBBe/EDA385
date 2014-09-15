

#include <stdio.h>
#include "platform.h"
#include "tmrctr_v2_04_a/src/xtmrctr.h"

#include "xuartlite_l.h"
#include "xparameters.h"

void print(char *str);

int feed(int* a, int n)
{
    int b = a[0];
    int i;
    for (i = 1; i < n; i++){
        //b = gcd_bin(a[i], b);
        putfsl(a[i], 0);
        putfsl(b, 0);
        getfsl(b, 0);
    }
    return b;
}

unsigned getnum(){
	char srb=0;
	unsigned num=0;

	// skip non digits
	while(srb < '0' || srb > '9') srb=XUartLite_RecvByte(STDIN_BASEADDRESS);

	// read all digits
	while(srb >= '0' && srb <= '9') {
		num=num*10+(srb-'0');
		srb=XUartLite_RecvByte(STDIN_BASEADDRESS);
	};
	return num;
}

int main()
{
    init_platform();

    XTmrCtr timer;
    XTmrCtr_Initialize(&timer, 0);

    //read input data
    xil_printf("input n\n\r");
    int n = getnum();
    int a[n];
    int i;
    for (i= 0; i < n; i++){
    	//xil_printf("input number %d\n\r", i);
    	a[i] = getnum();
    }
    xil_printf("done with input\n\r");

    XTmrCtr_Start(&timer, 0); //TIMER

    int result = feed(a, n);

    XTmrCtr_Stop(&timer, 0);
    int c = XTmrCtr_GetValue(&timer, 0);
    xil_printf("result = %d\n\r", result);
    xil_printf("bin clock cycles = %d\n\r", c);

    cleanup_platform();

    return 0;
}
