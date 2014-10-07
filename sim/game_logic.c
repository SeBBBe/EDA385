#include <stdio.h>

#include "vga.h"
#include "input.h"
#include "graphics.h"
#include "game_objects.h"

static const float rotate_amount = 0.07;
static const float ship_accel = 0.02;
static const float bullet_speed = 4;
int shoot_limit = 0;

typedef struct bullet
{
  f_vgapoint_t p1;
  f_vgapoint_t p2;
  float xvel;
  float yvel;
} bullet_t;

void game_over()
{
	vga_clear();
	offset(6, graphic_game_over, vga_get_width()/2 - 150, vga_get_height()/2 - 150);
	vga_addpoly(6, graphic_game_over);
	vga_sync();
	while(1);
}

void win()
{
	vga_clear();
	offset(4, graphic_vict, vga_get_width()/2 - 150, vga_get_height()/2 - 150);
	vga_addpoly(4, graphic_vict);
	vga_sync();
	while(1);
}

void game_main()
{
  keymap_t keys;
  vga_init();
  
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
  for (i = 0; i < 4; i++){
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
		  bullet_o->xvel = bullet_speed * cosine(ship_o->angle + 4.71);
		  bullet_o->yvel = bullet_speed * sine(ship_o->angle + 4.71);
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
		ship_o->xvel += ship_accel * cosine(ship_o->angle + 4.71);
		ship_o->yvel += ship_accel * sine(ship_o->angle + 4.71);
    }  
    /*if(keys & KEY_DOWN)
    {
		ship_o->angle += 3.14;
    }*/
    
    if (shoot_limit > 0) shoot_limit--;
    if (go_currentstate == STATE_DEAD) game_over();
    if (go_currentstate == STATE_VICT) win();
    
    vga_clear();
    go_draw();
  }
}
