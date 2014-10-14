#include <stdio.h>
#include <math.h>

int main(int argc, char *argv[])
{
	float v;
	for (v = 0; v < 6.29; v+=0.03)
	{
		printf("%f,",(float)sin(v));
	}
}
