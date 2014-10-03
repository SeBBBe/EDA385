#include <stdio.h>
#include <math.h>

int main(int argc, char *argv[])
{
	double v;
	for (v = 0; v < 6.29; v+=0.01)
	{
		printf("%f,",cos(v));
	}
}
