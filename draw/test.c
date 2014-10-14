#include <stdio.h>

#include "vga.h"
#include "input.h"

vgapoint_t test_ship[4] = {
  { 320, 230 },
  { 310, 250 },
  { 320, 245 },
  { 330, 250 },
};

vgapoint_t test_asteroid[5] = {
  { 70, 20 },
  { 30, 40 },
  { 50, 70 },
  { 80, 70 },
  { 100, 40 },
};

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
    
    vga_addpoly(4, test_ship);
    
    vga_addpoly(5, test_asteroid);
  }
}
