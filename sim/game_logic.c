#include <stdio.h>

#include "vga.h"
#include "input.h"
#include "graphics.c"

static const double rotate_amount = 0.07;
static const double ship_accel = 0.02;
double ship_x = 0;
double ship_y = 0;
double ship_rotation = 0;
double ship_xvel = 0;
double ship_yvel = 0;

typedef struct bullet
{
  vgapos_t x, y;
  double xvel;
  double yvel;
} bullet_t;

int main(int argc, char *argv[])
{
  keymap_t keys;
  vga_init();
  
  while(1)
  {
    vga_sync();
    
    keys = input_get_keys();
    if(keys & KEY_SHOOT)
    {
      printf("shoot!\n");
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
    
    //ship animation
    ship_x += ship_xvel;
	ship_y += ship_yvel;
	if (ship_rotation > 6.28) ship_rotation = 0;
	if (ship_rotation < 0) ship_rotation = 6.28;
    vgapoint_t* newship = rotate(4, ship, ship_rotation, 320, 240);
    offset(4, newship, ship_x, ship_y);
    
    vga_addpoly(4, newship);
    vga_addpoly(5, asteroid);
    
    usleep(20000);
  }
}
