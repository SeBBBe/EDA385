#include <stdio.h>

#include "vga.h"
#include "input.h"
#include "graphics.h"
#include "game_objects.h"

static const float rotate_amount = 0.07;
static const float ship_accel = 0.02;
static const float bullet_speed = 4;
vgapoint_t wtf[51] = {{310,535},{200,300},{100,530},{195,465},{305,525},{435,385},{340,385},{340,460},{445,460},{445,535},{325,535},{490,385},{605,385},{555,385},{555,530},{665,385},{770,385},{665,385},{665,445},{780,445},{660,445},{660,530},{790,530},{835,385},{835,530},{835,380},{910,410},{835,440},{920,520},{960,390},{1045,390},{1045,530},{970,530},{970,395},{1085,395},{1155,395},{1120,395},{1120,525},{1075,525},{1160,525},{1200,390},{1200,530},{1260,465},{1205,385},{1285,385},{1375,385},{1280,385},{1280,455},{1355,455},{1355,535},{1275,535}};
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
  
  game_object_t* drawing = go_getempty();
  	drawing->enabled = 1;
	drawing->poly_points = 256;
  	drawing->poly = calloc(drawing->poly_points * sizeof(short) * 2, 1);
	int i;
	i = 0;
	
	  game_object_t* fuck = go_getempty();
  	fuck->enabled = 1;
  	fuck->identifier = OI_LOGO;
	fuck->poly_points = 51;
	fuck->poly = calloc(fuck->poly_points * sizeof(short) * 2, 1);
  	fuck->poly = wtf;
  	fuck->anglespeed = 0.03;
  	fuck->center_point.x = vga_get_width()/2 + 75;
  	fuck->angle = 3.14;
  fuck->center_point.y = vga_get_height()/2;
  fuck->scale = 0.01;
  fuck->scaleaccel = 0.006;
	
/*vgapoint_t logo[4] = 
{
  {,},
};*/
  
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
			drawing->poly[i].x = ship_o->location.x+ship_o->center_point.x;
			drawing->poly[i].y = ship_o->location.y+ship_o->center_point.y;
			i++;
			drawing->poly_points = i;
			printf("{%d,%d},", (int)ship_o->location.x+(int)ship_o->center_point.x, (int)ship_o->location.y+(int)ship_o->center_point.x);
		}
    }
    ship_o->xvel = 0;
    ship_o->yvel = 0;
    if(keys & KEY_LEFT)
    {
      ship_o->xvel=- 5;
    }
    if(keys & KEY_RIGHT)
    {
		ship_o->xvel= + 5;
    }
    if(keys & KEY_UP)
    {
		ship_o->yvel =- 5;
    }
    if(keys & KEY_DOWN)
    {
		ship_o->yvel =+ 5;
    }
    
    if (shoot_limit > 0) shoot_limit--;
    if (go_currentstate == STATE_DEAD) game_over();
    if (go_currentstate == STATE_VICT) win();
    
    vga_clear();
    go_draw();
  }
}
