#include <stdio.h>

#include "vga.h"
#include "input.h"
#include "graphics.c"
#include "game_objects.c"

static const double rotate_amount = 0.07;
static const double ship_accel = 0.02;
static const double bullet_speed = 4;
double ship_x = 0;
double ship_y = 0;
double ship_rotation = 0;
double ship_xvel = 0;
double ship_yvel = 0;
int bullet_c = 0;

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
  
  while(1)
  {
	  go_tick();
    vga_sync();
    
    keys = input_get_keys();
    if(keys & KEY_SHOOT)
    {
      bullets[0].p1.x = ship_x + 320;
      bullets[0].p1.y = ship_y + 240;
      bullets[0].xvel = bullet_speed * cos(ship_rotation + 4.71);
      bullets[0].yvel = bullet_speed * sin(ship_rotation + 4.71);
      bullets[0].p2.x = bullets[0].p1.x + bullets[0].xvel*4;
      bullets[0].p2.y = bullets[0].p1.y + bullets[0].yvel*4;
    }
    if(keys & KEY_LEFT)
    {
      ship_rotation -= rotate_amount;
    }
    if(keys & KEY_RIGHT)
    {
	  ship_rotation += rotate_amount;
    }
    if(keys & KEY_UP)
    {
		//TODO: lookup table
		ship_xvel += ship_accel * cos(ship_rotation + 4.71);
		ship_yvel += ship_accel * sin(ship_rotation + 4.71);
    }  
    if(keys & KEY_DOWN)
    {
		ship_rotation += 3.14;
    }
    
    vga_clear();
    
    //animation
    ship_x += ship_xvel;
	ship_y += ship_yvel;
	bullets[0].p1.x += bullets[0].xvel;
	bullets[0].p1.y += bullets[0].yvel;
	bullets[0].p2.x += bullets[0].xvel;
	bullets[0].p2.y += bullets[0].yvel;
	if (ship_rotation > 6.28) ship_rotation = 0;
	if (ship_rotation < 0) ship_rotation = 6.28;
    vgapoint_t* newship = rotate(4, ship, ship_rotation, 320, 240);
    offset(4, newship, ship_x, ship_y);
    
    vga_addpoly(4, newship);
    vga_addpoly(5, asteroid);
    vgapoint_t b0p1 = {(short) bullets[0].p1.x, (short) bullets[0].p1.y};
    vgapoint_t b0p2 = {(short) bullets[0].p2.x, (short) bullets[0].p2.y};
    vgapoint_t b[2] = {b0p1, b0p2};
    vga_addpoly(2, b);
  }
}
