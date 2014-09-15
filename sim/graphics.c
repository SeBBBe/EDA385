#include <math.h>

vgapoint_t ship[4] = 
{
  { 320, 230 },
  { 310, 250 },
  { 320, 245 },
  { 330, 250 },
};

vgapoint_t asteroid[5] = 
{
  { 70, 20 },
  { 30, 40 },
  { 50, 70 },
  { 80, 70 },
  { 100, 40 },
};

//Rotate the polygon poly of n points, rad radians around the point (x_pivot, y_pivot)
vgapoint_t* rotate(int n, vgapoint_t *poly, double rad, int x_pivot, int y_pivot)
{
	//TODO: lookup table
	vgapoint_t* newpoly = malloc(sizeof(short) * 2 * n);
	
	int i;
	for (i = 0; i < n; i++)
	{
		double x = (double)poly[i].x - x_pivot; // Translate to origin
		double y = (double)poly[i].y - y_pivot;
		double c = cos(rad);
		double s = sin(rad);
		int newx = x * c - y * s + 0.5;
		int newy = x * s + y * c + 0.5;
		newx += x_pivot; // Reset position
		newy += y_pivot;
		newpoly[i].x = newx;
		newpoly[i].y = newy;
	}
	
	return newpoly;
}
