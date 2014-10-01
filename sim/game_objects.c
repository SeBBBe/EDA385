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
	short nowrap;
	short identifier;
	short hitbox_size;
	vgapoint_t* poly;
} game_object_t;

static const short MAX_OBJECTS = 64;
static const short OFFSCREEN_TOL = 100; //number of pixels outside screen before object is reset

short go_currentstate = 0;

static const short STATE_NORMAL = 0;
static const short STATE_DEAD = 1;
static const short STATE_VICT = 2;

game_object_t* objects;
short currentpos = 0;

void go_resetobject(int i)
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
		objects[i].nowrap = 0;
		objects[i].identifier = 0;
		objects[i].hitbox_size = 0;
}

void go_initialize()
{
	objects =  calloc(MAX_OBJECTS * sizeof(game_object_t), 1);
}

//Called when a hit was detected between object hit1 and hit2
void go_hashit(int hit1, int hit2)
{
	if (objects[hit2].identifier >= OI_AST1 && objects[hit2].identifier <= OI_AST4){
		if (objects[hit1].identifier == OI_SHIP){
			printf("Ship was hit by asteroid.\n");
			go_currentstate = STATE_DEAD;
		}
		if (objects[hit1].identifier == OI_BULLET){
			printf("Asteroid was hit by bullet.\n");
			objects[hit2].enabled = 0;
			if (!go_exists(OI_AST1) && !go_exists(OI_AST2) && !go_exists(OI_AST3) && !go_exists(OI_AST4))
			{
				printf("No asteroids remain. Player wins.\n");
				go_currentstate = STATE_VICT;
			}
		}
	}
}

//Detect hits
void go_hitdetection()
{
	int i;
	for (i = 0; i < MAX_OBJECTS; i++)
	{
		if (!objects[i].enabled) continue;
		if (objects[i].identifier != OI_SHIP && objects[i].identifier != OI_BULLET) continue;
		int j;
		for (j = 0; j < MAX_OBJECTS; j++)
		{
			if (!objects[j].enabled || i == j) continue;
			int realx1, realx2, realy1, realy2;
			int hitbox = objects[j].hitbox_size;
			realx1 = objects[i].location.x + objects[i].center_point.x;
			realy1 = objects[i].location.y + objects[i].center_point.y;
			realx2 = objects[j].location.x + objects[j].center_point.x;
			realy2 = objects[j].location.y + objects[j].center_point.y;
			if (realx1 > (realx2 - hitbox) && realx1 < (realx2 + hitbox))
			{
				if (realy1 > (realy2 - hitbox) && realy1 < (realy2 + hitbox))
				{
					go_hashit(i, j);
				}
			}
		}
	}
}

//returns 1 if object of current identifier exists in game, else 0
int go_exists(int identifier)
{
	int i;
	for (i = 0; i < MAX_OBJECTS; i++)
	{
		if (objects[i].enabled && objects[i].identifier == identifier) return 1;
	}
	return 0;
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
	go_hitdetection();
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
			free(newpoly);
			
			int realx = objects[i].location.x + objects[i].center_point.x;
			int realy = objects[i].location.y + objects[i].center_point.y;
			if (realx < -OFFSCREEN_TOL){
				if (objects[i].nowrap) objects[i].enabled = 0;
				objects[i].location.x = vga_get_width()+OFFSCREEN_TOL-objects[i].center_point.x;
			}
			if (realx > vga_get_width()+OFFSCREEN_TOL){
				if (objects[i].nowrap) objects[i].enabled = 0;
				objects[i].location.x = -OFFSCREEN_TOL -objects[i].center_point.x;;
			}
			if (realy < -OFFSCREEN_TOL){
				if (objects[i].nowrap) objects[i].enabled = 0;
				objects[i].location.y = vga_get_height()+OFFSCREEN_TOL-objects[i].center_point.y;
			}
			if (realy > vga_get_height()+OFFSCREEN_TOL){
				if (objects[i].nowrap) objects[i].enabled = 0;
				objects[i].location.y = -OFFSCREEN_TOL -objects[i].center_point.y;
			}
		}
	}
}

game_object_t* go_getempty(){
	while(objects[currentpos].enabled) //this will freeze if max number is reached
	{
		currentpos++;
		if (currentpos > MAX_OBJECTS) currentpos = 0;
	}
	int r = currentpos;
	currentpos++;
	go_resetobject(r);
	return &objects[r];
}

float rand_FloatRange(float a, float b)
{
	return ((b-a)*((float)rand()/RAND_MAX))+a;
}

//Create an asteroid of level n and place in game
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
	ast_o->identifier = OI_AST1;
	ast_o->hitbox_size = 25;
}
