#include <stdio.h>

#include "vga.h"
#include "input.h"
#include "graphics.c"
#include "game_objects.c"

static const double rotate_amount = 0.07;
static const double ship_accel = 0.02;
static const double bullet_speed = 4;
int shoot_limit = 0;

typedef struct bullet
{
  f_vgapoint_t p1;
  f_vgapoint_t p2;
  double xvel;
  double yvel;
} bullet_t;

int main(int argc, char *argv[])
{
  keymap_t keys;
  vga_init();
  bullet_t* bullets = malloc(64*sizeof(bullet_t));
  
  go_initialize();
  
  game_object_t* ship_o = go_getempty();
  ship_o->enabled = 1;
  ship_o->poly_points = 4;
  ship_o->poly = ship;
  
  while(1)
  {
	go_tick();
    vga_sync();
    
    keys = input_get_keys();
    if(keys & KEY_SHOOT)
    {
		if (shoot_limit == 0)
		{
			shoot_limit = 10;
			game_object_t* bullet_o = go_getempty();
		  bullet_o->location.x = ship_o->location.x;
		  bullet_o->location.y = ship_o->location.y;
		  bullet_o->xvel = bullet_speed * cos(ship_o->angle + 4.71);
		  bullet_o->yvel = bullet_speed * sin(ship_o->angle + 4.71);
		  bullet_o->angle = ship_o->angle;
		  bullet_o->enabled = 1;
		  bullet_o->poly = bullet_p;
		  bullet_o->poly_points = 2;
		}
    }
    if(keys & KEY_LEFT)
    {
      ship_o->angle -= rotate_amount;
    }
    if(keys & KEY_RIGHT)
    {
		ship_o->angle += rotate_amount;
    }
    if(keys & KEY_UP)
    {
		//TODO: lookup table
		ship_o->xvel += ship_accel * cos(ship_o->angle + 4.71);
		ship_o->yvel += ship_accel * sin(ship_o->angle + 4.71);
    }  
    if(keys & KEY_DOWN)
    {
		ship_o->angle += 3.14;
    }
    
    if (shoot_limit > 0) shoot_limit--;
    
    vga_clear();
    go_draw();
    
    vga_addpoly(5, asteroid);
  }
}
