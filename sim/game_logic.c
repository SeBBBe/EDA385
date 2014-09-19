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
  srand(time(NULL));
  
  game_object_t* ship_o = go_getempty();
  ship_o->enabled = 1;
  ship_o->poly_points = 4;
  ship_o->poly = ship;
  ship_o->center_point.x = 320;
  ship_o->center_point.y = 240;
  ship_o->location.x = vga_get_width()/2 - 320;
  ship_o->location.y = vga_get_height()/2 - 240;
  ship_o->identifier = OI_SHIP;
  
   int i;
  for (i = 0; i < 10; i++){
	go_createasteroid(1);
	}
  
  while(1)
  {
	go_tick();
    vga_sync();
    
    keys = input_get_keys();
    if(keys & KEY_SHOOT)
    {
		if (shoot_limit == 0)
		{
			shoot_limit = 25;
			game_object_t* bullet_o = go_getempty();
		  bullet_o->location.x = ship_o->location.x;
		  bullet_o->location.y = ship_o->location.y;
		  bullet_o->xvel = bullet_speed * cos(ship_o->angle + 4.71);
		  bullet_o->yvel = bullet_speed * sin(ship_o->angle + 4.71);
		  bullet_o->center_point.x = 320;
          bullet_o->center_point.y = 240;
		  bullet_o->angle = ship_o->angle;
		  bullet_o->enabled = 1;
		  bullet_o->poly = bullet_p;
		  bullet_o->poly_points = 2;
		  bullet_o->nowrap = 1;
		  bullet_o->identifier = OI_BULLET;
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
  }
}
