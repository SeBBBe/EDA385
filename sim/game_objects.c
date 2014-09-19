#include <time.h>
#include <stdlib.h>

typedef struct game_object {
	f_vgapoint_t location;
	f_vgapoint_t center_point;
	double xvel;
	double yvel;
	double xaccel;
	double yaccel;
	double angle;
	double anglespeed;
	short enabled;
	short poly_points;
	vgapoint_t* poly;
} game_object_t;

static const short MAX_OBJECTS = 64;

game_object_t* objects;
short currentpos = 0;

void go_initialize()
{
	objects =  malloc(MAX_OBJECTS * sizeof(game_object_t));
	int i;
	for (i = 0; i < MAX_OBJECTS; i++)
	{
		objects[i].location.x = 0;
		objects[i].location.y = 0;
		objects[i].center_point.x = 0;
		objects[i].center_point.y = 0;
		objects[i].xvel = 0;
		objects[i].yvel = 0;
		objects[i].xaccel = 0;
		objects[i].yaccel = 0;
		objects[i].angle = 0;
		objects[i].anglespeed = 0;
		objects[i].poly_points = 0;
		objects[i].enabled = 0;
	}
}

void go_tick()
{
	int i;
	for (i = 0; i < MAX_OBJECTS; i++)
	{
		objects[i].location.x += objects[i].xvel;
		objects[i].location.y += objects[i].yvel;
		objects[i].xvel += objects[i].xaccel;
		objects[i].yvel += objects[i].yaccel;
		objects[i].angle += objects[i].anglespeed;
	}
}

void go_draw()
{
	int i;
	for (i = 0; i < MAX_OBJECTS; i++)
	{
		if (objects[i].enabled)
		{
			if (objects[i].angle > 6.28) objects[i].angle = 0;
			if (objects[i].angle < 0) objects[i].angle = 6.28;
			vgapoint_t* newpoly = rotate(objects[i].poly_points, objects[i].poly, objects[i].angle, objects[i].center_point.x, objects[i].center_point.y);
			offset(objects[i].poly_points, newpoly, objects[i].location.x, objects[i].location.y);
			vga_addpoly(objects[i].poly_points, newpoly);
		}
	}
}

game_object_t* go_getempty(){
	if (currentpos > MAX_OBJECTS) currentpos = 0;
	int r = currentpos;
	currentpos++;
	return &objects[r];
}

float rand_FloatRange(float a, float b)
{
	return ((b-a)*((float)rand()/RAND_MAX))+a;
}

//Create an asteroid of poly size n and place in game
void go_createasteroid(int n)
{
	//TODO: generate asteroid geometry
	game_object_t* ast_o = go_getempty();
	ast_o->enabled = 1;
	ast_o->poly_points = 5;
	ast_o->poly = asteroid;
	ast_o->location.x = rand() % vga_get_width();
	ast_o->location.y = rand() % vga_get_height();
	ast_o->xvel = rand_FloatRange(0.0, 4.0) - 2.0;
	ast_o->yvel = rand_FloatRange(0.0, 4.0) - 2.0;
	ast_o->anglespeed = rand_FloatRange(0.0, 0.4) - 0.2;
	ast_o->center_point.x = 65;
	ast_o->center_point.y = 45;
}
