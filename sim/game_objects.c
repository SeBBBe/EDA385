typedef struct game_object {
	f_vgapoint_t location;
	double xvel;
	double yvel;
	double xaccel;
	double yaccel;
	double angle;
	short enabled;
	short poly_points;
	vgapoint_t* poly;
} game_object_t;

static const short MAX_OBJECTS = 64;

game_object_t* objects;
short currentpos = 0;

void go_initialize()
{
	objects =  malloc(MAX_OBJECTS * sizeof(game_object_t));
	int i;
	for (i = 0; i < MAX_OBJECTS; i++)
	{
		objects[i].location.x = 0;
		objects[i].location.y = 0;
		objects[i].xvel = 0;
		objects[i].yvel = 0;
		objects[i].xaccel = 0;
		objects[i].yaccel = 0;
		objects[i].angle = 0;
		objects[i].poly_points = 0;
		objects[i].enabled = 0;
	}
}

void go_tick()
{
	int i;
	for (i = 0; i < MAX_OBJECTS; i++)
	{
		objects[i].location.x += objects[i].xvel;
		objects[i].location.y += objects[i].yvel;
		objects[i].xvel += objects[i].xaccel;
		objects[i].yvel += objects[i].yaccel;
	}
}

void go_draw()
{
	int i;
	for (i = 0; i < MAX_OBJECTS; i++)
	{
		if (objects[i].enabled)
		{
			if (objects[i].angle > 6.28) objects[i].angle = 0;
			if (objects[i].angle < 0) objects[i].angle = 6.28;
			vgapoint_t* newpoly = rotate(objects[i].poly_points, objects[i].poly, objects[i].angle, 320, 240);
			offset(objects[i].poly_points, newpoly, objects[i].location.x, objects[i].location.y);
			vga_addpoly(objects[i].poly_points, newpoly);
		}
	}
}

game_object_t* go_getempty(){
	if (currentpos > MAX_OBJECTS) currentpos = 0;
	int r = currentpos;
	currentpos++;
	return &objects[r];
}
