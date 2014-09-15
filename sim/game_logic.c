#include <stdio.h>

#include "vga.h"
#include "input.h"
#include "graphics.c"

static const double rotate_amount = 0.07;

int main(int argc, char *argv[])
{
  keymap_t keys;
  
  vga_init();
  
  double ship_rotation = 0;
  
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
      printf("up\n");
    }  
    if(keys & KEY_DOWN)
    {
      printf("down\n");
    }
    
    vga_clear();
    
    vga_addpoly(4, rotate(4, ship, ship_rotation, 320, 240));
    
    vga_addpoly(5, asteroid);
    
    usleep(20000);
  }
}
