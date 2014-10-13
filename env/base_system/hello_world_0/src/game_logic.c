#include <stdio.h>

#include "memmgr.h"

#include "vga.h"
#include "input.h"
#include "snd.h"

static const float rotate_amount = 0.07;
static const float ship_accel = 0.2;
static const float ship_fric = 0.02;
static float bullet_speed = 16;
int shoot_limit = 0;
int shoot_buffer = 0;
short pup1 = 0; // powerup1 = bullet

#include "graphics.h"
#include "game_objects.h"

typedef struct bullet
{
  f_vgapoint_t p1;
  f_vgapoint_t p2;
  float xvel;
  float yvel;
} bullet_t;

sample_t gameover[] = {
		{168, 100, 0},
		{200, 100, 0},
		{300, 100, 0},
		{400, 100, 0},
		{500, 100, 0},
		{600, 100, 0},
		{700, 100, 0},
		{800, 100, 0},
};

void game_over()
{
	vgapoint_t *poly = copy_poly(6, graphic_game_over);
	offset(6, poly, vga_get_width()/2 - 150, vga_get_height()/2 - 150);

	snd_play(gameover, sizeof(gameover) / sizeof(*gameover));

	while(1)
	{
		vga_clear();
		snd_update();
		vga_addpoly_color(6, poly, 0b00000111);
		vga_sync();
	}
}

sample_t winsnd[] = {
		{168, 20, 0},
		{150, 20, 0},
		{134, 20, 0},
		{126, 20, 0},
		{113, 20, 0},
		{100, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{100, 20, 0},
		{113, 20, 0},
		{126, 20, 0},
		{134, 20, 0},
		{150, 20, 0},
		{168, 20, 0},
		{168, 20, 0},
		{150, 20, 0},
		{134, 20, 0},
		{126, 20, 0},
		{113, 20, 0},
		{100, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{100, 20, 0},
		{113, 20, 0},
		{126, 20, 0},
		{134, 20, 0},
		{150, 20, 0},
		{168, 20, 0},
		{168, 20, 0},
		{150, 20, 0},
		{134, 20, 0},
		{126, 20, 0},
		{113, 20, 0},
		{100, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{100, 20, 0},
		{113, 20, 0},
		{126, 20, 0},
		{134, 20, 0},
		{150, 20, 0},
		{168, 20, 0},
		{168, 20, 0},
		{150, 20, 0},
		{168, 20, 0},
		{168, 20, 0},
		{20000, 4, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{20000, 4, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{20000, 2, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
};

void win()
{
	vgapoint_t *poly = copy_poly(4, graphic_vict);
	offset(4, poly, vga_get_width()/2 - 150, vga_get_height()/2 - 150);

	snd_play(winsnd, sizeof(winsnd) / sizeof(*winsnd));

	while(1)
	{
		vga_clear();
		snd_update();
		vga_addpoly_color(4, poly, 0b00111000);
		vga_sync();
	}
}

sample_t shoot[] = {
		{168, 2, 0},
		{150, 2, 0},
		{134, 2, 0},
		{126, 2, 0},
		{113, 2, 0},
		{100, 2, 0},
		{89, 2, 0},
		{84, 2, 0},
};
/*TODO BY JAW
*	Make astroids more difficult to kill -> add hp for objects, check if hp = 0, remove obj.
*	Add powerups for bullet2. (CHECK)
*	Change graphic for bullet2
*	Add a way to spawn Powerups.
*	Change Win song? Add bgm?
*	Add end game with mothership spawning bullets towards ship and spawning astroids.
*/
void game_main()
{
  keymap_t keys;
  vga_init();
  snd_init();
  
  go_initialize();
  srand(1339);
  
  bullet_speed = 10;

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
  for (i = 0; i < 6; i++){
	go_createasteroid(1);
  }
  go_createpowerupn(1,600,650);

  while(1)
  {
	go_tick();
    vga_sync();

    snd_update();

    keys = input_get_keys();
    float bullet2angle = 0.0;
    if(keys & KEY_SHOOT)
    {
		if (shoot_limit == 0)
		{
			if(pup1){ // if powerup1 is active
			game_object_t* bullet2_o = go_getempty();
			bullet2angle = 0.1;
		  bullet2_o->location.x = ship_o->location.x;
		  bullet2_o->location.y = ship_o->location.y;
		  bullet2_o->xvel = (ship_o->xvel) + bullet_speed * cosine(ship_o->angle-bullet2angle + 4.71);
		  bullet2_o->yvel = (ship_o->yvel) + bullet_speed * sine(ship_o->angle-bullet2angle + 4.71);
		  bullet2_o->center_point.x = 320;
		  bullet2_o->center_point.y = 240;
		  bullet2_o->angle = ship_o->angle-bullet2angle;
		  bullet2_o->enabled = 1;
		  bullet2_o->poly = bullet_p;
		  bullet2_o->poly_points = 2;
		  bullet2_o->nowrap = 1;
		  bullet2_o->identifier = OI_BULLET;
		  }else{
			  bullet2angle = 0;
		  }

			shoot_limit = 15;
			if (shoot_buffer == 0) shoot_limit = 60;
			game_object_t* bullet_o = go_getempty();
		  bullet_o->location.x = ship_o->location.x;
		  bullet_o->location.y = ship_o->location.y;
		  bullet_o->xvel = (ship_o->xvel) + bullet_speed * cosine(ship_o->angle+bullet2angle + 4.71);
		  bullet_o->yvel = (ship_o->yvel) + bullet_speed * sine(ship_o->angle+bullet2angle + 4.71);
		  bullet_o->center_point.x = 320;
          bullet_o->center_point.y = 240;
		  bullet_o->angle = ship_o->angle+bullet2angle;
		  bullet_o->enabled = 1;
		  bullet_o->poly = bullet_p;
		  bullet_o->poly_points = 2;
		  bullet_o->nowrap = 1;
		  bullet_o->identifier = OI_BULLET;

		  snd_play(shoot, sizeof(shoot) / sizeof(*shoot));
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
    if (go_currentstate == STATE_VICT || (*dip & 8)) win();
    
    vga_clear();
    go_draw();
  }
}
