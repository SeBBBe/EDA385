#include <stdio.h>
#include <malloc.h>
#include <SDL/SDL.h>

#include "vga.h"
#include "input.h"

#define SIM_WIDTH 640
#define SIM_HEIGHT 480
#define SIM_MAX_POLY 16

struct sim_poly
{
  int num_points;
  vgapoint_t *points;
} polygons[SIM_MAX_POLY];

int polygon_index;

SDL_Surface *window;

keymap_t input;

void vga_init()
{
  polygon_index = 0;
  
  if(SDL_Init(SDL_INIT_VIDEO|SDL_INIT_NOPARACHUTE) != 0)
  {
    printf("error initializing SDL\n");
    exit(-1);
  }
  
  window = SDL_SetVideoMode(SIM_WIDTH, SIM_HEIGHT, 32, SDL_SWSURFACE);
  
  if(window == NULL)
  {
    printf("error creating window\n");
    exit(-1);
  }
  
  SDL_WM_SetCaption("VGA Simulator", NULL);
}

int vga_addpoly(int num_points, vgapoint_t *points)
{
	int i;
	for (i = 0; i < num_points; i++)
	{
		if (points[i].x < 0 || points[i].y < 0) return 0;
		if (points[i].x > vga_get_width() || points[i].y > vga_get_height()) return 0;
	}
  if(polygon_index == SIM_MAX_POLY) return 0;
  
  polygons[polygon_index].num_points = num_points;
  polygons[polygon_index].points = malloc(sizeof(*points) * num_points);
  
  memcpy(polygons[polygon_index].points, points, sizeof(*points) * num_points);
  
  polygon_index++;
  
  return 1;
}

void vga_clear()
{
  int i;
  
  for(i = 0; i < polygon_index; i++) free(polygons[i].points);
  
  polygon_index = 0;
}

void bresenham(int *pixels, int pitch, int x0, int y0, int x1, int y1)
{
  int dx = abs(x1-x0), sx = x0<x1 ? 1 : -1;
  int dy = abs(y1-y0), sy = y0<y1 ? 1 : -1; 
  int err = (dx>dy ? dx : -dy)/2, e2;

  for(;;){
    pixels[x0 + y0 * (pitch / 4)] = 0xFFFFFFFF;
    if (x0==x1 && y0==y1) break;
    e2 = err;
    if (e2 >-dx) { err -= dy; x0 += sx; }
    if (e2 < dy) { err += dx; y0 += sy; }
  }
}

void vga_sync()
{
  int i, j;
  int *pixels;
  SDL_Event event;
  
  SDL_FillRect(window, NULL, 0);
  
  SDL_LockSurface(window);
  
  pixels = (int *)window->pixels;
  
  for(i = 0; i < polygon_index; i++)
  {
    for(j = 0; j < polygons[i].num_points; j++)
    {
      vgapos_t x0, y0, x1, y1;
      
      x0 = polygons[i].points[j].x;
      y0 = polygons[i].points[j].y;
      x1 = polygons[i].points[(j + 1) % polygons[i].num_points].x;
      y1 = polygons[i].points[(j + 1) % polygons[i].num_points].y;
      
      bresenham(pixels, window->pitch, x0, y0, x1, y1);
    }
  }
  
  SDL_UnlockSurface(window);
  
  SDL_Flip(window);
  
  while(SDL_PollEvent(&event))
  {
    keymap_t keys = 0;
    
    switch(event.type)
    {
      case SDL_QUIT:
	exit(-1);
	break;
      case SDL_KEYDOWN:
      case SDL_KEYUP:
	switch(event.key.keysym.sym)
	{
	  case SDLK_LEFT:
	    keys |= KEY_LEFT;
	    break;
	  case SDLK_RIGHT:
	    keys |= KEY_RIGHT;
	    break;
	  case SDLK_UP:
	    keys |= KEY_UP;
	    break;
	  case SDLK_DOWN:
	    keys |= KEY_DOWN;
	    break;
	  case SDLK_SPACE:
	    keys |= KEY_SHOOT;
	    break;
	}
	
	if(event.type == SDL_KEYDOWN) input |= keys;
	else input &= ~keys;
	
	break;
    }
  }
}

vgapos_t vga_get_width()
{
  return SIM_WIDTH;
}

vgapos_t vga_get_height()
{
  return SIM_HEIGHT;
}

keymap_t input_get_keys()
{
  return input;
}
