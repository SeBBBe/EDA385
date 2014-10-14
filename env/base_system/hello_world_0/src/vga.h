typedef short vgapos_t;

typedef struct vga_point
{
  vgapos_t x, y;
} vgapoint_t;

typedef struct f_vga_point
{
  float x, y;
} f_vgapoint_t;

typedef unsigned char color_t;

void vga_init();
int vga_addpoly(int num_points, vgapoint_t *points);
int vga_addpoly_color(int num_points, vgapoint_t *points, color_t color);
int vga_addpoly_color2(int num_points, vgapoint_t *points, color_t color, int rainbow);
void vga_clear();
void vga_sync();
vgapos_t vga_get_width();
vgapos_t vga_get_height();
