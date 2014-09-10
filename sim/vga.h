
typedef unsigned short vgapos_t;

typedef struct vga_point
{
  vgapos_t x, y;
} vgapoint_t;

void vga_init();
int vga_addpoly(int num_points, vgapoint_t *points);
void vga_clear();
void vga_sync();
vgapos_t vga_get_width();
vgapos_t vga_get_height();
