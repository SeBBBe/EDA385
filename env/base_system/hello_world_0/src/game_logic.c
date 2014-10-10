#include <stdio.h>

#include "memmgr.h"

#include "vga.h"
#include "input.h"

static const float rotate_amount = 0.07;
static const float ship_accel = 0.2;
static const float ship_fric = 0.02;
static float bullet_speed = 10;
int shoot_limit = 0;
int shoot_buffer = 0;

#include "graphics.h"
#include "game_objects.h"
typedef struct bullet
{
  f_vgapoint_t p1;
  f_vgapoint_t p2;
  float xvel;
  float yvel;
} bullet_t;

void game_over()
{
	vgapoint_t *poly = copy_poly(6, graphic_game_over);
	offset(6, poly, vga_get_width()/2 - 150, vga_get_height()/2 - 150);

	while(1)
	{
		vga_clear();
		vga_addpoly_color(6, poly, 0b00000111);
		vga_sync();
	}
}

void win()
{
	vgapoint_t *poly = copy_poly(4, graphic_vict);
	offset(4, poly, vga_get_width()/2 - 150, vga_get_height()/2 - 150);

	while(1)
	{
		vga_clear();
		vga_addpoly_color(4, poly, 0b00111000);
		vga_sync();
	}
}

void game_main()
{
  keymap_t keys;
  vga_init();
  
  go_initialize();
  srand(1339);
  
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
  for (i = 0; i < 2; i++){
	go_createasteroid(1);
  }
  go_createpowerupn(1,600,350);
  
  while(1)
  {
	go_tick();
    vga_sync();
    
    keys = input_get_keys();
    if(keys & KEY_SHOOT)
    {
		if (shoot_limit == 0)
		{
			shoot_limit = 15;
			if (shoot_buffer == 0) shoot_limit = 60;
			game_object_t* bullet_o = go_getempty();
		  bullet_o->location.x = ship_o->location.x;
		  bullet_o->location.y = ship_o->location.y;
		  bullet_o->xvel = (ship_o->xvel) + bullet_speed * cosine(ship_o->angle + 4.71);
		  bullet_o->yvel = (ship_o->yvel) + bullet_speed * sine(ship_o->angle + 4.71);
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
    	shoot_buffer += 4;
    	if (shoot_buffer > 300) shoot_buffer = 300;
		//TODO: lookup table
		ship_o->xvel += ship_accel * cosine(ship_o->angle + 4.71);
		ship_o->yvel += ship_accel * sine(ship_o->angle + 4.71);
    }

    ship_o->xvel += ship_fric * -ship_o->xvel;
    ship_o->yvel += ship_fric * -ship_o->yvel;
    if (shoot_buffer > 0) shoot_buffer--;

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
