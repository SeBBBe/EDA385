#include <stdio.h>

#include "vga.h"
#include "input.h"

#define VGA_WIDTH 1280
#define VGA_HEIGHT 960
#define VGA_MAX_LINES 256

#define INPUT_BASE_ADDRESS 0x40000000
#define VGA_BASE_ADDRESS 0x7F800000

int volatile *vga = 0x7F800000;

struct vga_line
{
  vgapoint_t p0;
  vgapoint_t p1;
} lines[VGA_MAX_LINES];

int line_index;

void vga_init()
{
  line_index = 0;
}

int vga_addpoly(int num_points, vgapoint_t *points)
{
  int i;
  
  if(line_index + num_points >= VGA_MAX_LINES) return 0;

  for(i = 0; i < num_points; i++)
  {
    vgapos_t x0, y0, x1, y1, tmp;
  
    x0 = points[i].x;
    y0 = points[i].y;
    x1 = points[(i + 1) % num_points].x;
    y1 = points[(i + 1) % num_points].y;
	
	// VGA controller requires y0 to be above or on the same row as y1
	if(y0 > y1)
	{
      tmp = y1;
	  y1 = y0;
	  y0 = tmp;
	  
	  tmp = x1;
	  x1 = x0;
	  x0 = tmp;
	}
  
    lines[line_index].p0.x = x0;
	lines[line_index].p0.y = y0;
	lines[line_index].p1.x = x1;
	lines[line_index].p1.y = y1;
	
	line_index++;
  }
  
  return 1;
}

void vga_clear()
{
  line_index = 0;
}

void vga_sync()
{
  int i, p0, p1;

  // wait for vsync
  while(!*vga);
  
  // all 256 lines must be pushed to the VGA controller every frame to clear the shift register
  for(i = 0; i < VGA_MAX_LINES; i++)
  {
    if(i < line_index)
	{
	  p0 = lines[i].p0.x | (lines[i].p0.y << 16);
	  p1 = lines[i].p1.x | (lines[i].p1.y << 16);
	}
	else
	{
	  p0 = 0;
	  p1 = 0;
	}
  
    *vga = p0;
    *vga = p1;
  }
  
  // wait for end of vsync
  while(*vga);
}

vgapos_t vga_get_width()
{
  return VGA_WIDTH;
}

vgapos_t vga_get_height()
{
  return VGA_HEIGHT;
}

// input mapping: ULDR

keymap_t input_get_keys()
{
  int keys = *((int *)INPUT_BASE_ADDRESS);
  keymap_t input = 0;
  
  if(keys & 1) input |= KEY_RIGHT;
  if(keys & 2) input |= KEY_SHOOT;
  if(keys & 4) input |= KEY_LEFT;
  if(keys & 8) input |= KEY_UP;

  return input;
}
