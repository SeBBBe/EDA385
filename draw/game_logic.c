#include <stdio.h>

#include "vga.h"
#include "input.h"
#include "graphics.h"
#include "game_objects.h"

static const float rotate_amount = 0.07;
static const float ship_accel = 0.01;
static const float bullet_speed = 4;
vgapoint_t wtf[9] = {{660,590},{690,590},{700,600},{700,620},{680,620},{660,620},{700,650},{660,620},{660,650}};
// C = {640,510},{590,510},{590,570},{640,570},{590,570},{590,510}};
// R = {660,590},{690,590},{700,600},{700,620},{680,620},{660,620},{700,650},{660,620},{660,650}};
// E = {660,590},{690,590},{700,600},{700,620},{680,620},{660,620},{700,650},{660,620},{660,650}
// D = {660,590},{690,590},{700,600},{700,620},{680,620},{660,620},{700,650},{660,620},{660,650}
// I = {720,670},{760,670},{740,670},{740,730},{720,730},{760,730},{740,730},{740,670},
// T = {720,670},{760,670},{740,670},{740,730},{740,670},
// S = {770,670},{720,670},{720,700},{770,700},{770,730},{720,730},{770,730},{770,700},{720,700},{720,670},

// TAO = {540,520},{560,510},{610,510},{630,520},{610,510},{590,510},{590,570},{590,510},{610,510},{630,520},{630,540},{620,550},{630,540},{650,540},{660,550},{660,570},{620,570},{620,560},{660,560},{660,570},{670,570},{670,540},{690,540},{700,550},{700,570},{670,570},{660,570},{660,550},{650,540},{630,540},{630,520},{610,510},{560,510},{540,520},{590,510}

// FIGURE HUMAN = {640,440},{630,450},{630,460},{640,470},{650,470},{660,460},{660,450},{650,440},{650,540},{650,500},{620,480},{650,500},{680,480},{650,500},{650,540},{620,560},{650,540},{680,560},{650,540},{650,440}

// AALI = {410,500},{450,390},{480,500},{450,480},{540,490},{540,450},{510,450},{500,460},{500,480},{510,490},{530,490},{540,480},{560,390},{560,500},{580,430},{580,500},{410,500},{450,480}

// FABIAN = {520,530},{520,450},{540,420},{560,410},{560,440},{540,460},{490,480},{550,480},{540,500},{560,480},{570,490},{580,530},{560,500},{540,510},{540,530},{580,530},{590,530},{590,440},{590,490},{600,490},{610,500},{620,520},{620,530},{590,530},{620,530},{630,530},{640,520},{640,500},{640,460},{630,460},{650,530},{670,530},{670,510},{690,500},{710,530},{710,490},{700,480},{680,470},{670,490},{680,470},{700,480},{710,490},{710,530},{730,530},{730,490},{730,530},{750,500},{760,490},{770,490},{770,530},

// ZHAO = {440,430},{510,430},{440,500},{510,500},{520,460},{520,500},{520,480},{550,480},{550,460},{550,500},{560,500},{570,460},{580,460},{590,460},{600,500},{560,480},{610,480},{620,460},{640,460},{650,480},{640,500},{620,500},{610,480},{560,480},{560,500},{550,500},{550,480},{520,480},{520,460},{510,500},{440,500},{510,430},

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
  
	  game_object_t* fuck = go_getempty();
  	fuck->enabled = 1;
  	fuck->identifier = OI_SHIP;
	fuck->poly_points = 9;
	fuck->poly = calloc(fuck->poly_points * sizeof(short) * 2, 1);
  	fuck->poly = wtf;
  	fuck->anglespeed = 0.00;
  	fuck->center_point.x = vga_get_width()/2 + 75;
  	fuck->angle = 0;
  fuck->center_point.y = vga_get_height()/2;
  fuck->scale = 0.0;
  fuck->scaleaccel = 0.000;

	
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
      ship_o->xvel=- 10;
    }
    if(keys & KEY_RIGHT)
    {
		ship_o->xvel= + 10;
		
    }
    if(keys & KEY_UP)
    {
		ship_o->yvel =- 10;
    }
    if(keys & KEY_DOWN)
    {
		ship_o->yvel =+ 10;
    }
    
    if (shoot_limit > 0) shoot_limit--;
    if (go_currentstate == STATE_DEAD) game_over();
    if (go_currentstate == STATE_VICT) win();
    
    vga_clear();
    go_draw();
  }
}
