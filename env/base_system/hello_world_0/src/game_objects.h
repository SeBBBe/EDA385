#include <stdlib.h>

typedef struct game_object {
	f_vgapoint_t location;
	f_vgapoint_t center_point;
	float xvel;
	float yvel;
	float xaccel;
	float yaccel;
	float scale;
	float scaleaccel;
	float angle;
	float anglespeed;
	short hp;
	short enabled;
	short poly_points;
	short identifier;
	short hitbox_size;
	vgapoint_t* poly;
} game_object_t;

static const short MAX_OBJECTS = 64;
static const short OFFSCREEN_TOL = 100; //number of pixels outside screen before object is reset

short go_currentstate;

static const short STATE_NORMAL = 0;
static const short STATE_DEAD = 1;
static const short STATE_VICT = 2;

game_object_t* objects;
short currentpos = 0;

extern int volatile *dip;

void go_createpowerupn(int n, float x, float y);
void go_createasteroidxy(int n, float x, float y);
int go_exists(int identifier);

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
		objects[i].scale = 0;
		objects[i].scaleaccel = 0;
		objects[i].angle = 0;
		objects[i].anglespeed = 0;
		objects[i].hp = 0;
		objects[i].poly_points = 0;
		objects[i].enabled = 0;
		objects[i].identifier = 0;
		objects[i].hitbox_size = 0;
}

void go_initialize()
{
	int i;

	objects = memmgr_alloc(MAX_OBJECTS * sizeof(game_object_t));

	for(i = 0; i < MAX_OBJECTS; i++)
	{
		go_resetobject(i);
	}

	go_currentstate = 0;

	currentpos = 0;

	//xil_printf("objects = %x\r\n", objects);
}

//Called when a hit was detected between object hit1 and hit2
void go_hashit(int hit1, int hit2)
{

	if (!objects[hit1].enabled) return;
	if (!objects[hit2].enabled) return;
	// Ship take powerup
	if (objects[hit1].identifier == OI_SHIP && objects[hit2].identifier == OI_PUP1){
		objects[hit2].enabled = 0;
		pup1 = 1;
		SND_PLAY(pup1snd);
	}
	if (objects[hit2].identifier >= OI_AST1 && objects[hit2].identifier <= OI_AST4){
		if (objects[hit1].identifier == OI_SHIP && !(*dip & 2)/* DIP1 = god mode */){
			go_currentstate = STATE_DEAD;
		}
		if (objects[hit1].identifier == OI_BULLET || (objects[hit1].identifier == OI_SHIP && (*dip & 2))){
			objects[hit2].hp--;
			if(objects[hit2].hp == 0){
				if (objects[hit2].identifier == OI_AST1)
				{
					go_createasteroidxy(2, objects[hit2].location.x, objects[hit2].location.y);
					go_createasteroidxy(2, objects[hit2].location.x, objects[hit2].location.y);
					go_createasteroidxy(2, objects[hit2].location.x, objects[hit2].location.y);

					if( (rand() % 100) < 20  && pup_has_already_spawned == 0){
						go_createpowerupn(1, objects[hit2].location.x, objects[hit2].location.y);
						pup_has_already_spawned = 1;
					}
				}
				else if (objects[hit2].identifier == OI_AST2)
				{
					go_createasteroidxy(3, objects[hit2].location.x, objects[hit2].location.y);
					go_createasteroidxy(3, objects[hit2].location.x, objects[hit2].location.y);
					go_createasteroidxy(3, objects[hit2].location.x, objects[hit2].location.y);

					if( (rand() % 100) < 5  && pup_has_already_spawned == 0){
						go_createpowerupn(1, objects[hit2].location.x, objects[hit2].location.y);
						pup_has_already_spawned = 1;
					}
				}

				objects[hit2].enabled = 0;
				memmgr_free(objects[hit2].poly);
				SND_PLAY(kaboom);
			}else{
				SND_PLAY(kaboom_short);
			}

			if(objects[hit1].identifier != OI_SHIP) objects[hit1].enabled = 0;
			if (!go_exists(OI_AST1) && !go_exists(OI_AST2) && !go_exists(OI_AST3) && !go_exists(OI_AST4))
			{
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
					break;
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
		if(objects[i].enabled)
		{
			if (objects[i].identifier == OI_LOGO && objects[i].angle > 6.1) continue;
			objects[i].location.x += objects[i].xvel;
			objects[i].location.y += objects[i].yvel;
			objects[i].xvel += objects[i].xaccel;
			objects[i].yvel += objects[i].yaccel;
			objects[i].angle += objects[i].anglespeed;
			objects[i].scale += objects[i].scaleaccel;

			if(objects[i].identifier == OI_BULLET)
			{
				if(!objects[i].hp--) objects[i].enabled = 0;
			}
		}
	}
	go_hitdetection();
}

void go_draw()
{
	int i;
	static color_t stonecolor[5] = {0b11111111, // vit
									0b11110110, // gr�are
									0b10100100, // gr�2
									0b01010010, // gr�3
									0b00000101	// dj�vulsr�d
	};


	for (i = 0; i < MAX_OBJECTS; i++)
	{
		if (objects[i].enabled)
		{

			if (objects[i].angle > 6.28) objects[i].angle -= 6.28;
			if (objects[i].angle < 0) objects[i].angle += 6.28;
			vgapoint_t* newpoly = rotate(objects[i].poly_points, objects[i].poly, objects[i].angle, objects[i].center_point.x, objects[i].center_point.y);
			if (objects[i].scale != 0) scale(objects[i].poly_points, newpoly, objects[i].scale, objects[i].center_point.x, objects[i].center_point.y);
			offset(objects[i].poly_points, newpoly, objects[i].location.x, objects[i].location.y);

			//Add poly with color
			switch(objects[i].identifier)
			{
				case 1: vga_addpoly_color(objects[i].poly_points, newpoly, (*dip & 2) ? 0b11000111 : 0b00111000);    break; //ship
				case 2: vga_addpoly_color(objects[i].poly_points, newpoly, (*dip & 2) ? 0b00111000 : 0b11000111);   break; //bullet
				case 3: vga_addpoly_color(objects[i].poly_points, newpoly, stonecolor[3]); break; //ast1
				case 4:	vga_addpoly_color(objects[i].poly_points, newpoly, stonecolor[2]); break; //ast2
				case 5:	vga_addpoly_color(objects[i].poly_points, newpoly, stonecolor[1]); break; //ast3
 				case 6: vga_addpoly_color(objects[i].poly_points, newpoly, stonecolor[0]); break; //ast4
 				case 7: vga_addpoly_color(objects[i].poly_points, newpoly, stonecolor[4]); break; //pup1
 				case 8: vga_addpoly_color2(objects[i].poly_points, newpoly, stonecolor[4], 1); break; //logo
 				default: vga_addpoly_color(objects[i].poly_points, newpoly, stonecolor[0]); break; //default
			}

			memmgr_free(newpoly);
			
			int realx = objects[i].location.x + objects[i].center_point.x;
			int realy = objects[i].location.y + objects[i].center_point.y;
			if (realx < -OFFSCREEN_TOL){
				objects[i].location.x = vga_get_width()+OFFSCREEN_TOL-objects[i].center_point.x;
			}
			if (realx > vga_get_width()+OFFSCREEN_TOL){
				objects[i].location.x = -OFFSCREEN_TOL -objects[i].center_point.x;;
			}
			if (realy < -OFFSCREEN_TOL){
				objects[i].location.y = vga_get_height()+OFFSCREEN_TOL-objects[i].center_point.y;
			}
			if (realy > vga_get_height()+OFFSCREEN_TOL){
				objects[i].location.y = -OFFSCREEN_TOL -objects[i].center_point.y;
			}
		}
	}
}

game_object_t* go_getempty(){
	while(objects[currentpos].enabled) //this will freeze if max number is reached
	{
		currentpos++;
		if (currentpos >= MAX_OBJECTS) currentpos = 0;
	}
	int r = currentpos;
	currentpos++;
	if (currentpos >= MAX_OBJECTS) currentpos = 0;
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
	go_createasteroidxy(n, (float)(rand() % vga_get_width()), (float)(rand() % vga_get_height()));
}

void go_createpowerupn(int n, float x, float y)
{
	short center = 20;
	short hitbox = 30;

	game_object_t* pup_o = go_getempty();
	pup_o->identifier = OI_PUP1;
	pup_o->enabled = 1;
	pup_o->poly_points = 5;
	pup_o->poly = powerup_1;
	pup_o->location.x = x;
	pup_o->location.y = y;
	pup_o->xvel = 0.5;
	pup_o->yvel = 0.5;
	pup_o->anglespeed = 0.03;
	pup_o->center_point.x = center;
	pup_o->center_point.y = center;
	pup_o->hitbox_size = hitbox;
}

void go_createasteroidxy(int n, float x, float y)
{
	game_object_t* ast_o = go_getempty();
	ast_o->enabled = 1;
	ast_o->poly_points = 8;
	
	vgapoint_t *polypointer;
	int randdev;
	int center;
	int hitbox;
	short hp;
	float speed;
	if (n == 1)
	{
		polypointer = asteroid_r1;
		randdev = 120;
		hitbox = 75;
		center = 80;
		speed = 1.8;
		hp = 3;
		ast_o->identifier = OI_AST1;
	}
	if (n == 2)
	{
		polypointer = asteroid_r2;
		randdev = 60;
		hitbox = 35;
		center = 40;
		speed = 6.0;
		hp = 2;
		ast_o->identifier = OI_AST2;
	}
	if (n == 3)
	{
		polypointer = asteroid_r3;
		randdev = 30;
		hitbox = 20;
		center = 20;
		speed = 10.0;
		hp = 1;
		ast_o->identifier = OI_AST3;
	}
	
	ast_o->poly = copy_poly(ast_o->poly_points, polypointer);

	int i;
	for (i = 0; i < ast_o->poly_points; i++)
	{
		ast_o->poly[i].x += (rand() % randdev) - (randdev/2);
	}
	
	ast_o->location.x = x;
	ast_o->location.y = y;
	ast_o->xvel = rand_FloatRange(0.0, speed) - (speed/2);
	ast_o->yvel = rand_FloatRange(0.0, speed) - (speed/2);
	ast_o->anglespeed = rand_FloatRange(0.0, speed/15) - (speed/30);
	ast_o->center_point.x = center;
	ast_o->center_point.y = center;
	ast_o->hitbox_size = hitbox;
	ast_o->hp = hp;
}

void go_createbullet(game_object_t *source, float angle)
{
	game_object_t* bullet_o = go_getempty();
	bullet_o->location.x = source->location.x;
	bullet_o->location.y = source->location.y;
	bullet_o->xvel = (source->xvel) + bullet_speed * cosine(source->angle+angle + 4.71);
	bullet_o->yvel = (source->yvel) + bullet_speed * sine(source->angle+angle + 4.71);
	bullet_o->center_point.x = 320;
	bullet_o->center_point.y = 240;
	bullet_o->angle = source->angle+angle;
	bullet_o->enabled = 1;
	bullet_o->poly = bullet_p;
	bullet_o->poly_points = 2;
	bullet_o->hp = 90;
	bullet_o->identifier = OI_BULLET;
}
