#include <stdio.h>

#include "vga.h"
#include "input.h"
#include "graphics.c"

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
      printf("left\n");
    }
    
    if(keys & KEY_RIGHT)
    {
      printf("right\n");
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
    
    vga_addpoly(4, ship);
    
    vga_addpoly(5, asteroid);
  }
}
